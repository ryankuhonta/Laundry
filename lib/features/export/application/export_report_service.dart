import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../customers/data/laundry_repository.dart';
import '../domain/export_snapshot.dart';

class ExportReportService {
  ExportReportService(this._repository);

  static const _downloadsChannel = MethodChannel(
    'laundry_loyalty_program/downloads',
  );

  final LaundryRepository _repository;

  Future<String> exportExcelReport() async {
    if (kIsWeb) {
      throw UnsupportedError('Excel export is not available on web yet.');
    }

    final snapshot = await _repository.getExportSnapshot();
    final bytes = _buildWorkbook(snapshot);
    final filename =
        'laundry-report-${DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now())}.xlsx';
    if (Platform.isAndroid) {
      final savedPath = await _downloadsChannel.invokeMethod<String>(
        'saveToDownloads',
        {'filename': filename, 'bytes': Uint8List.fromList(bytes)},
      );
      return savedPath ?? 'Downloads/Laundry Loyalty Exports/$filename';
    }

    final directory = await _exportDirectory();
    final file = File(p.join(directory.path, filename));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Directory> _exportDirectory() async {
    final baseDirectory = await getDownloadsDirectory();
    final directory = Directory(
      p.join(
        (baseDirectory ?? await getApplicationDocumentsDirectory()).path,
        'Laundry Loyalty Exports',
      ),
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  List<int> _buildWorkbook(ExportSnapshot snapshot) {
    final sheets = [
      _Worksheet('Summary', _summaryRows(snapshot)),
      _Worksheet('Customers', _customerRows(snapshot)),
      _Worksheet('Visits', _visitRows(snapshot)),
      _Worksheet('Payments', _paymentRows(snapshot)),
    ];

    final archive = Archive();
    void addText(String name, String content) {
      final bytes = content.codeUnits;
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    addText('[Content_Types].xml', _contentTypes(sheets.length));
    addText('_rels/.rels', _rootRelationships());
    addText('xl/workbook.xml', _workbook(sheets));
    addText(
      'xl/_rels/workbook.xml.rels',
      _workbookRelationships(sheets.length),
    );
    addText('xl/styles.xml', _styles());
    for (var index = 0; index < sheets.length; index++) {
      addText(
        'xl/worksheets/sheet${index + 1}.xml',
        _worksheet(sheets[index].rows),
      );
    }

    return ZipEncoder().encode(archive);
  }

  List<List<Object?>> _summaryRows(ExportSnapshot snapshot) {
    return [
      ['Metric', 'Value'],
      ['Exported at', _dateTime(snapshot.exportedAt)],
      ['Reward threshold', snapshot.rewardThreshold],
      ['Total customers', snapshot.totalCustomers],
      ['Total visits', snapshot.totalVisits],
      ['Paid visits', snapshot.paidVisits],
      ['Unpaid visits', snapshot.unpaidVisits],
      ['Total sales', snapshot.totalSales],
      ['Total paid loads', snapshot.totalPaidLoads],
      ['Free loads redeemed', snapshot.freeLoadsRedeemed],
    ];
  }

  List<List<Object?>> _customerRows(ExportSnapshot snapshot) {
    return [
      [
        'Customer ID',
        'Name',
        'Mobile Number',
        'Address',
        'Total Visits',
        'Total Paid Loads',
        'Free Loads Available',
        'Free Loads Redeemed',
        'Loads Until Next Free Load',
        'Last Visit Date',
        'Customer Created Date',
      ],
      ...snapshot.customers.map(
        (customer) => [
          customer.id,
          customer.name,
          customer.mobileNumber,
          customer.address,
          customer.totalVisits,
          customer.totalLoads,
          customer.availableFreeLoads,
          customer.freeLoadsRedeemed,
          customer.loadsUntilNextFreeLoad,
          _nullableDateTime(customer.lastVisitDate),
          _dateTime(customer.createdAt),
        ],
      ),
    ];
  }

  List<List<Object?>> _visitRows(ExportSnapshot snapshot) {
    return [
      [
        'Visit ID',
        'Visit Date',
        'Customer Name',
        'Mobile Number',
        'Paid Loads',
        'Free Load Redeemed',
        'Payment Status',
        'Payment Date',
        'Payment Amount',
        'Signature Path',
      ],
      ...snapshot.visits.map(
        (visit) => [
          visit.visitId,
          _dateTime(visit.visitDate),
          visit.customerName,
          visit.mobileNumber,
          visit.loadCount,
          _yesNo(visit.freeLoadRedeemed),
          visit.isPaid ? 'Paid' : 'Unpaid',
          _nullableDateTime(visit.paymentDate),
          visit.paymentAmount,
          visit.signatureImagePath,
        ],
      ),
    ];
  }

  List<List<Object?>> _paymentRows(ExportSnapshot snapshot) {
    final paidVisits = snapshot.visits.where((visit) => visit.isPaid);
    return [
      [
        'Payment Date',
        'Visit Date',
        'Customer Name',
        'Mobile Number',
        'Paid Loads',
        'Free Load Redeemed',
        'Amount Paid',
      ],
      ...paidVisits.map(
        (visit) => [
          _nullableDateTime(visit.paymentDate),
          _dateTime(visit.visitDate),
          visit.customerName,
          visit.mobileNumber,
          visit.loadCount,
          _yesNo(visit.freeLoadRedeemed),
          visit.paymentAmount,
        ],
      ),
    ];
  }

  String _worksheet(List<List<Object?>> rows) {
    final rowXml = <String>[];
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final cells = rows[rowIndex];
      final cellXml = <String>[];
      for (var columnIndex = 0; columnIndex < cells.length; columnIndex++) {
        cellXml.add(_cell(rowIndex + 1, columnIndex + 1, cells[columnIndex]));
      }
      rowXml.add('<row r="${rowIndex + 1}">${cellXml.join()}</row>');
    }

    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <sheetData>${rowXml.join()}</sheetData>
</worksheet>
''';
  }

  String _cell(int row, int column, Object? value) {
    final reference = '${_columnName(column)}$row';
    if (value is num) {
      return '<c r="$reference"><v>$value</v></c>';
    }
    final text = _escapeXml(value?.toString() ?? '');
    return '<c r="$reference" t="inlineStr"><is><t>$text</t></is></c>';
  }

  String _columnName(int column) {
    var value = column;
    final buffer = StringBuffer();
    while (value > 0) {
      value--;
      buffer.writeCharCode(65 + (value % 26));
      value ~/= 26;
    }
    return buffer.toString().split('').reversed.join();
  }

  String _contentTypes(int sheetCount) {
    final sheetOverrides = List.generate(
      sheetCount,
      (index) =>
          '<Override PartName="/xl/worksheets/sheet${index + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>',
    ).join();
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  $sheetOverrides
</Types>
''';
  }

  String _rootRelationships() {
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
''';
  }

  String _workbook(List<_Worksheet> sheets) {
    final sheetXml = <String>[];
    for (var index = 0; index < sheets.length; index++) {
      sheetXml.add(
        '<sheet name="${_escapeXml(sheets[index].name)}" sheetId="${index + 1}" r:id="rId${index + 1}"/>',
      );
    }
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>${sheetXml.join()}</sheets>
</workbook>
''';
  }

  String _workbookRelationships(int sheetCount) {
    final relationships = <String>[];
    for (var index = 0; index < sheetCount; index++) {
      relationships.add(
        '<Relationship Id="rId${index + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${index + 1}.xml"/>',
      );
    }
    relationships.add(
      '<Relationship Id="rId${sheetCount + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>',
    );
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  ${relationships.join()}
</Relationships>
''';
  }

  String _styles() {
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="1"><font><sz val="11"/><name val="Calibri"/></font></fonts>
  <fills count="1"><fill><patternFill patternType="none"/></fill></fills>
  <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
</styleSheet>
''';
  }

  String _dateTime(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

  String _nullableDateTime(DateTime? dateTime) =>
      dateTime == null ? '' : _dateTime(dateTime);

  String _yesNo(bool value) => value ? 'Yes' : 'No';

  String _escapeXml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}

class _Worksheet {
  const _Worksheet(this.name, this.rows);

  final String name;
  final List<List<Object?>> rows;
}
