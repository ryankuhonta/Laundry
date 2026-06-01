// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mobileNumberMeta = const VerificationMeta(
    'mobileNumber',
  );
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
    'mobile_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mobileNumber,
    name,
    address,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
        _mobileNumberMeta,
        mobileNumber.isAcceptableOrUnknown(
          data['mobile_number']!,
          _mobileNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mobileNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mobileNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRecord extends DataClass implements Insertable<CustomerRecord> {
  final int id;
  final String mobileNumber;
  final String name;
  final String address;
  final DateTime createdAt;
  const CustomerRecord({
    required this.id,
    required this.mobileNumber,
    required this.name,
    required this.address,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mobile_number'] = Variable<String>(mobileNumber);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      mobileNumber: Value(mobileNumber),
      name: Value(name),
      address: Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRecord(
      id: serializer.fromJson<int>(json['id']),
      mobileNumber: serializer.fromJson<String>(json['mobileNumber']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mobileNumber': serializer.toJson<String>(mobileNumber),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerRecord copyWith({
    int? id,
    String? mobileNumber,
    String? name,
    String? address,
    DateTime? createdAt,
  }) => CustomerRecord(
    id: id ?? this.id,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    name: name ?? this.name,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomerRecord copyWithCompanion(CustomersCompanion data) {
    return CustomerRecord(
      id: data.id.present ? data.id.value : this.id,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRecord(')
          ..write('id: $id, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mobileNumber, name, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRecord &&
          other.id == this.id &&
          other.mobileNumber == this.mobileNumber &&
          other.name == this.name &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerRecord> {
  final Value<int> id;
  final Value<String> mobileNumber;
  final Value<String> name;
  final Value<String> address;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String mobileNumber,
    required String name,
    required String address,
    this.createdAt = const Value.absent(),
  }) : mobileNumber = Value(mobileNumber),
       name = Value(name),
       address = Value(address);
  static Insertable<CustomerRecord> custom({
    Expression<int>? id,
    Expression<String>? mobileNumber,
    Expression<String>? name,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? mobileNumber,
    Value<String>? name,
    Value<String>? address,
    Value<DateTime>? createdAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VisitsTable extends Visits with TableInfo<$VisitsTable, VisitRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitDateMeta = const VerificationMeta(
    'visitDate',
  );
  @override
  late final GeneratedColumn<DateTime> visitDate = GeneratedColumn<DateTime>(
    'visit_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _signatureImagePathMeta =
      const VerificationMeta('signatureImagePath');
  @override
  late final GeneratedColumn<String> signatureImagePath =
      GeneratedColumn<String>(
        'signature_image_path',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _loadCountMeta = const VerificationMeta(
    'loadCount',
  );
  @override
  late final GeneratedColumn<int> loadCount = GeneratedColumn<int>(
    'load_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _freeLoadRedeemedMeta = const VerificationMeta(
    'freeLoadRedeemed',
  );
  @override
  late final GeneratedColumn<bool> freeLoadRedeemed = GeneratedColumn<bool>(
    'free_load_redeemed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("free_load_redeemed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentAmountMeta = const VerificationMeta(
    'paymentAmount',
  );
  @override
  late final GeneratedColumn<double> paymentAmount = GeneratedColumn<double>(
    'payment_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    visitDate,
    signatureImagePath,
    loadCount,
    freeLoadRedeemed,
    isPaid,
    paymentDate,
    paymentAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('visit_date')) {
      context.handle(
        _visitDateMeta,
        visitDate.isAcceptableOrUnknown(data['visit_date']!, _visitDateMeta),
      );
    }
    if (data.containsKey('signature_image_path')) {
      context.handle(
        _signatureImagePathMeta,
        signatureImagePath.isAcceptableOrUnknown(
          data['signature_image_path']!,
          _signatureImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signatureImagePathMeta);
    }
    if (data.containsKey('load_count')) {
      context.handle(
        _loadCountMeta,
        loadCount.isAcceptableOrUnknown(data['load_count']!, _loadCountMeta),
      );
    }
    if (data.containsKey('free_load_redeemed')) {
      context.handle(
        _freeLoadRedeemedMeta,
        freeLoadRedeemed.isAcceptableOrUnknown(
          data['free_load_redeemed']!,
          _freeLoadRedeemedMeta,
        ),
      );
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
        _paymentAmountMeta,
        paymentAmount.isAcceptableOrUnknown(
          data['payment_amount']!,
          _paymentAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisitRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      visitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visit_date'],
      )!,
      signatureImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_image_path'],
      )!,
      loadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_count'],
      )!,
      freeLoadRedeemed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}free_load_redeemed'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      ),
      paymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payment_amount'],
      ),
    );
  }

  @override
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class VisitRecord extends DataClass implements Insertable<VisitRecord> {
  final int id;
  final int customerId;
  final DateTime visitDate;
  final String signatureImagePath;
  final int loadCount;
  final bool freeLoadRedeemed;
  final bool isPaid;
  final DateTime? paymentDate;
  final double? paymentAmount;
  const VisitRecord({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.signatureImagePath,
    required this.loadCount,
    required this.freeLoadRedeemed,
    required this.isPaid,
    this.paymentDate,
    this.paymentAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['visit_date'] = Variable<DateTime>(visitDate);
    map['signature_image_path'] = Variable<String>(signatureImagePath);
    map['load_count'] = Variable<int>(loadCount);
    map['free_load_redeemed'] = Variable<bool>(freeLoadRedeemed);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paymentDate != null) {
      map['payment_date'] = Variable<DateTime>(paymentDate);
    }
    if (!nullToAbsent || paymentAmount != null) {
      map['payment_amount'] = Variable<double>(paymentAmount);
    }
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      visitDate: Value(visitDate),
      signatureImagePath: Value(signatureImagePath),
      loadCount: Value(loadCount),
      freeLoadRedeemed: Value(freeLoadRedeemed),
      isPaid: Value(isPaid),
      paymentDate: paymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDate),
      paymentAmount: paymentAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentAmount),
    );
  }

  factory VisitRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitRecord(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      visitDate: serializer.fromJson<DateTime>(json['visitDate']),
      signatureImagePath: serializer.fromJson<String>(
        json['signatureImagePath'],
      ),
      loadCount: serializer.fromJson<int>(json['loadCount']),
      freeLoadRedeemed: serializer.fromJson<bool>(json['freeLoadRedeemed']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paymentDate: serializer.fromJson<DateTime?>(json['paymentDate']),
      paymentAmount: serializer.fromJson<double?>(json['paymentAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'visitDate': serializer.toJson<DateTime>(visitDate),
      'signatureImagePath': serializer.toJson<String>(signatureImagePath),
      'loadCount': serializer.toJson<int>(loadCount),
      'freeLoadRedeemed': serializer.toJson<bool>(freeLoadRedeemed),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paymentDate': serializer.toJson<DateTime?>(paymentDate),
      'paymentAmount': serializer.toJson<double?>(paymentAmount),
    };
  }

  VisitRecord copyWith({
    int? id,
    int? customerId,
    DateTime? visitDate,
    String? signatureImagePath,
    int? loadCount,
    bool? freeLoadRedeemed,
    bool? isPaid,
    Value<DateTime?> paymentDate = const Value.absent(),
    Value<double?> paymentAmount = const Value.absent(),
  }) => VisitRecord(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    visitDate: visitDate ?? this.visitDate,
    signatureImagePath: signatureImagePath ?? this.signatureImagePath,
    loadCount: loadCount ?? this.loadCount,
    freeLoadRedeemed: freeLoadRedeemed ?? this.freeLoadRedeemed,
    isPaid: isPaid ?? this.isPaid,
    paymentDate: paymentDate.present ? paymentDate.value : this.paymentDate,
    paymentAmount: paymentAmount.present
        ? paymentAmount.value
        : this.paymentAmount,
  );
  VisitRecord copyWithCompanion(VisitsCompanion data) {
    return VisitRecord(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      visitDate: data.visitDate.present ? data.visitDate.value : this.visitDate,
      signatureImagePath: data.signatureImagePath.present
          ? data.signatureImagePath.value
          : this.signatureImagePath,
      loadCount: data.loadCount.present ? data.loadCount.value : this.loadCount,
      freeLoadRedeemed: data.freeLoadRedeemed.present
          ? data.freeLoadRedeemed.value
          : this.freeLoadRedeemed,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      paymentAmount: data.paymentAmount.present
          ? data.paymentAmount.value
          : this.paymentAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitRecord(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('visitDate: $visitDate, ')
          ..write('signatureImagePath: $signatureImagePath, ')
          ..write('loadCount: $loadCount, ')
          ..write('freeLoadRedeemed: $freeLoadRedeemed, ')
          ..write('isPaid: $isPaid, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paymentAmount: $paymentAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    visitDate,
    signatureImagePath,
    loadCount,
    freeLoadRedeemed,
    isPaid,
    paymentDate,
    paymentAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitRecord &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.visitDate == this.visitDate &&
          other.signatureImagePath == this.signatureImagePath &&
          other.loadCount == this.loadCount &&
          other.freeLoadRedeemed == this.freeLoadRedeemed &&
          other.isPaid == this.isPaid &&
          other.paymentDate == this.paymentDate &&
          other.paymentAmount == this.paymentAmount);
}

class VisitsCompanion extends UpdateCompanion<VisitRecord> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<DateTime> visitDate;
  final Value<String> signatureImagePath;
  final Value<int> loadCount;
  final Value<bool> freeLoadRedeemed;
  final Value<bool> isPaid;
  final Value<DateTime?> paymentDate;
  final Value<double?> paymentAmount;
  const VisitsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.visitDate = const Value.absent(),
    this.signatureImagePath = const Value.absent(),
    this.loadCount = const Value.absent(),
    this.freeLoadRedeemed = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.paymentAmount = const Value.absent(),
  });
  VisitsCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    this.visitDate = const Value.absent(),
    required String signatureImagePath,
    this.loadCount = const Value.absent(),
    this.freeLoadRedeemed = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.paymentAmount = const Value.absent(),
  }) : customerId = Value(customerId),
       signatureImagePath = Value(signatureImagePath);
  static Insertable<VisitRecord> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<DateTime>? visitDate,
    Expression<String>? signatureImagePath,
    Expression<int>? loadCount,
    Expression<bool>? freeLoadRedeemed,
    Expression<bool>? isPaid,
    Expression<DateTime>? paymentDate,
    Expression<double>? paymentAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (visitDate != null) 'visit_date': visitDate,
      if (signatureImagePath != null)
        'signature_image_path': signatureImagePath,
      if (loadCount != null) 'load_count': loadCount,
      if (freeLoadRedeemed != null) 'free_load_redeemed': freeLoadRedeemed,
      if (isPaid != null) 'is_paid': isPaid,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
    });
  }

  VisitsCompanion copyWith({
    Value<int>? id,
    Value<int>? customerId,
    Value<DateTime>? visitDate,
    Value<String>? signatureImagePath,
    Value<int>? loadCount,
    Value<bool>? freeLoadRedeemed,
    Value<bool>? isPaid,
    Value<DateTime?>? paymentDate,
    Value<double?>? paymentAmount,
  }) {
    return VisitsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      visitDate: visitDate ?? this.visitDate,
      signatureImagePath: signatureImagePath ?? this.signatureImagePath,
      loadCount: loadCount ?? this.loadCount,
      freeLoadRedeemed: freeLoadRedeemed ?? this.freeLoadRedeemed,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (visitDate.present) {
      map['visit_date'] = Variable<DateTime>(visitDate.value);
    }
    if (signatureImagePath.present) {
      map['signature_image_path'] = Variable<String>(signatureImagePath.value);
    }
    if (loadCount.present) {
      map['load_count'] = Variable<int>(loadCount.value);
    }
    if (freeLoadRedeemed.present) {
      map['free_load_redeemed'] = Variable<bool>(freeLoadRedeemed.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<double>(paymentAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('visitDate: $visitDate, ')
          ..write('signatureImagePath: $signatureImagePath, ')
          ..write('loadCount: $loadCount, ')
          ..write('freeLoadRedeemed: $freeLoadRedeemed, ')
          ..write('isPaid: $isPaid, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('paymentAmount: $paymentAmount')
          ..write(')'))
        .toString();
  }
}

class $LoyaltySettingsTable extends LoyaltySettings
    with TableInfo<$LoyaltySettingsTable, LoyaltySettingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoyaltySettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _rewardThresholdMeta = const VerificationMeta(
    'rewardThreshold',
  );
  @override
  late final GeneratedColumn<int> rewardThreshold = GeneratedColumn<int>(
    'reward_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _staffPinMeta = const VerificationMeta(
    'staffPin',
  );
  @override
  late final GeneratedColumn<String> staffPin = GeneratedColumn<String>(
    'staff_pin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rewardThreshold, staffPin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loyalty_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoyaltySettingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reward_threshold')) {
      context.handle(
        _rewardThresholdMeta,
        rewardThreshold.isAcceptableOrUnknown(
          data['reward_threshold']!,
          _rewardThresholdMeta,
        ),
      );
    }
    if (data.containsKey('staff_pin')) {
      context.handle(
        _staffPinMeta,
        staffPin.isAcceptableOrUnknown(data['staff_pin']!, _staffPinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoyaltySettingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoyaltySettingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rewardThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_threshold'],
      )!,
      staffPin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_pin'],
      ),
    );
  }

  @override
  $LoyaltySettingsTable createAlias(String alias) {
    return $LoyaltySettingsTable(attachedDatabase, alias);
  }
}

class LoyaltySettingRecord extends DataClass
    implements Insertable<LoyaltySettingRecord> {
  final int id;
  final int rewardThreshold;
  final String? staffPin;
  const LoyaltySettingRecord({
    required this.id,
    required this.rewardThreshold,
    this.staffPin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reward_threshold'] = Variable<int>(rewardThreshold);
    if (!nullToAbsent || staffPin != null) {
      map['staff_pin'] = Variable<String>(staffPin);
    }
    return map;
  }

  LoyaltySettingsCompanion toCompanion(bool nullToAbsent) {
    return LoyaltySettingsCompanion(
      id: Value(id),
      rewardThreshold: Value(rewardThreshold),
      staffPin: staffPin == null && nullToAbsent
          ? const Value.absent()
          : Value(staffPin),
    );
  }

  factory LoyaltySettingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoyaltySettingRecord(
      id: serializer.fromJson<int>(json['id']),
      rewardThreshold: serializer.fromJson<int>(json['rewardThreshold']),
      staffPin: serializer.fromJson<String?>(json['staffPin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rewardThreshold': serializer.toJson<int>(rewardThreshold),
      'staffPin': serializer.toJson<String?>(staffPin),
    };
  }

  LoyaltySettingRecord copyWith({
    int? id,
    int? rewardThreshold,
    Value<String?> staffPin = const Value.absent(),
  }) => LoyaltySettingRecord(
    id: id ?? this.id,
    rewardThreshold: rewardThreshold ?? this.rewardThreshold,
    staffPin: staffPin.present ? staffPin.value : this.staffPin,
  );
  LoyaltySettingRecord copyWithCompanion(LoyaltySettingsCompanion data) {
    return LoyaltySettingRecord(
      id: data.id.present ? data.id.value : this.id,
      rewardThreshold: data.rewardThreshold.present
          ? data.rewardThreshold.value
          : this.rewardThreshold,
      staffPin: data.staffPin.present ? data.staffPin.value : this.staffPin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoyaltySettingRecord(')
          ..write('id: $id, ')
          ..write('rewardThreshold: $rewardThreshold, ')
          ..write('staffPin: $staffPin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rewardThreshold, staffPin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoyaltySettingRecord &&
          other.id == this.id &&
          other.rewardThreshold == this.rewardThreshold &&
          other.staffPin == this.staffPin);
}

class LoyaltySettingsCompanion extends UpdateCompanion<LoyaltySettingRecord> {
  final Value<int> id;
  final Value<int> rewardThreshold;
  final Value<String?> staffPin;
  const LoyaltySettingsCompanion({
    this.id = const Value.absent(),
    this.rewardThreshold = const Value.absent(),
    this.staffPin = const Value.absent(),
  });
  LoyaltySettingsCompanion.insert({
    this.id = const Value.absent(),
    this.rewardThreshold = const Value.absent(),
    this.staffPin = const Value.absent(),
  });
  static Insertable<LoyaltySettingRecord> custom({
    Expression<int>? id,
    Expression<int>? rewardThreshold,
    Expression<String>? staffPin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rewardThreshold != null) 'reward_threshold': rewardThreshold,
      if (staffPin != null) 'staff_pin': staffPin,
    });
  }

  LoyaltySettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? rewardThreshold,
    Value<String?>? staffPin,
  }) {
    return LoyaltySettingsCompanion(
      id: id ?? this.id,
      rewardThreshold: rewardThreshold ?? this.rewardThreshold,
      staffPin: staffPin ?? this.staffPin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rewardThreshold.present) {
      map['reward_threshold'] = Variable<int>(rewardThreshold.value);
    }
    if (staffPin.present) {
      map['staff_pin'] = Variable<String>(staffPin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoyaltySettingsCompanion(')
          ..write('id: $id, ')
          ..write('rewardThreshold: $rewardThreshold, ')
          ..write('staffPin: $staffPin')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $LoyaltySettingsTable loyaltySettings = $LoyaltySettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    visits,
    loyaltySettings,
  ];
}

typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String mobileNumber,
      required String name,
      required String address,
      Value<DateTime> createdAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> mobileNumber,
      Value<String> name,
      Value<String> address,
      Value<DateTime> createdAt,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRecord,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (
            CustomerRecord,
            BaseReferences<_$AppDatabase, $CustomersTable, CustomerRecord>,
          ),
          CustomerRecord,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mobileNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                mobileNumber: mobileNumber,
                name: name,
                address: address,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mobileNumber,
                required String name,
                required String address,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                mobileNumber: mobileNumber,
                name: name,
                address: address,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRecord,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (
        CustomerRecord,
        BaseReferences<_$AppDatabase, $CustomersTable, CustomerRecord>,
      ),
      CustomerRecord,
      PrefetchHooks Function()
    >;
typedef $$VisitsTableCreateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      required int customerId,
      Value<DateTime> visitDate,
      required String signatureImagePath,
      Value<int> loadCount,
      Value<bool> freeLoadRedeemed,
      Value<bool> isPaid,
      Value<DateTime?> paymentDate,
      Value<double?> paymentAmount,
    });
typedef $$VisitsTableUpdateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      Value<int> customerId,
      Value<DateTime> visitDate,
      Value<String> signatureImagePath,
      Value<int> loadCount,
      Value<bool> freeLoadRedeemed,
      Value<bool> isPaid,
      Value<DateTime?> paymentDate,
      Value<double?> paymentAmount,
    });

class $$VisitsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signatureImagePath => $composableBuilder(
    column: $table.signatureImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loadCount => $composableBuilder(
    column: $table.loadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get freeLoadRedeemed => $composableBuilder(
    column: $table.freeLoadRedeemed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signatureImagePath => $composableBuilder(
    column: $table.signatureImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loadCount => $composableBuilder(
    column: $table.loadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get freeLoadRedeemed => $composableBuilder(
    column: $table.freeLoadRedeemed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get visitDate =>
      $composableBuilder(column: $table.visitDate, builder: (column) => column);

  GeneratedColumn<String> get signatureImagePath => $composableBuilder(
    column: $table.signatureImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loadCount =>
      $composableBuilder(column: $table.loadCount, builder: (column) => column);

  GeneratedColumn<bool> get freeLoadRedeemed => $composableBuilder(
    column: $table.freeLoadRedeemed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => column,
  );
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitsTable,
          VisitRecord,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (
            VisitRecord,
            BaseReferences<_$AppDatabase, $VisitsTable, VisitRecord>,
          ),
          VisitRecord,
          PrefetchHooks Function()
        > {
  $$VisitsTableTableManager(_$AppDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<DateTime> visitDate = const Value.absent(),
                Value<String> signatureImagePath = const Value.absent(),
                Value<int> loadCount = const Value.absent(),
                Value<bool> freeLoadRedeemed = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<DateTime?> paymentDate = const Value.absent(),
                Value<double?> paymentAmount = const Value.absent(),
              }) => VisitsCompanion(
                id: id,
                customerId: customerId,
                visitDate: visitDate,
                signatureImagePath: signatureImagePath,
                loadCount: loadCount,
                freeLoadRedeemed: freeLoadRedeemed,
                isPaid: isPaid,
                paymentDate: paymentDate,
                paymentAmount: paymentAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int customerId,
                Value<DateTime> visitDate = const Value.absent(),
                required String signatureImagePath,
                Value<int> loadCount = const Value.absent(),
                Value<bool> freeLoadRedeemed = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<DateTime?> paymentDate = const Value.absent(),
                Value<double?> paymentAmount = const Value.absent(),
              }) => VisitsCompanion.insert(
                id: id,
                customerId: customerId,
                visitDate: visitDate,
                signatureImagePath: signatureImagePath,
                loadCount: loadCount,
                freeLoadRedeemed: freeLoadRedeemed,
                isPaid: isPaid,
                paymentDate: paymentDate,
                paymentAmount: paymentAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitsTable,
      VisitRecord,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (VisitRecord, BaseReferences<_$AppDatabase, $VisitsTable, VisitRecord>),
      VisitRecord,
      PrefetchHooks Function()
    >;
typedef $$LoyaltySettingsTableCreateCompanionBuilder =
    LoyaltySettingsCompanion Function({
      Value<int> id,
      Value<int> rewardThreshold,
      Value<String?> staffPin,
    });
typedef $$LoyaltySettingsTableUpdateCompanionBuilder =
    LoyaltySettingsCompanion Function({
      Value<int> id,
      Value<int> rewardThreshold,
      Value<String?> staffPin,
    });

class $$LoyaltySettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardThreshold => $composableBuilder(
    column: $table.rewardThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get staffPin => $composableBuilder(
    column: $table.staffPin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoyaltySettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardThreshold => $composableBuilder(
    column: $table.rewardThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get staffPin => $composableBuilder(
    column: $table.staffPin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoyaltySettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoyaltySettingsTable> {
  $$LoyaltySettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rewardThreshold => $composableBuilder(
    column: $table.rewardThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<String> get staffPin =>
      $composableBuilder(column: $table.staffPin, builder: (column) => column);
}

class $$LoyaltySettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoyaltySettingsTable,
          LoyaltySettingRecord,
          $$LoyaltySettingsTableFilterComposer,
          $$LoyaltySettingsTableOrderingComposer,
          $$LoyaltySettingsTableAnnotationComposer,
          $$LoyaltySettingsTableCreateCompanionBuilder,
          $$LoyaltySettingsTableUpdateCompanionBuilder,
          (
            LoyaltySettingRecord,
            BaseReferences<
              _$AppDatabase,
              $LoyaltySettingsTable,
              LoyaltySettingRecord
            >,
          ),
          LoyaltySettingRecord,
          PrefetchHooks Function()
        > {
  $$LoyaltySettingsTableTableManager(
    _$AppDatabase db,
    $LoyaltySettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoyaltySettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoyaltySettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoyaltySettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> rewardThreshold = const Value.absent(),
                Value<String?> staffPin = const Value.absent(),
              }) => LoyaltySettingsCompanion(
                id: id,
                rewardThreshold: rewardThreshold,
                staffPin: staffPin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> rewardThreshold = const Value.absent(),
                Value<String?> staffPin = const Value.absent(),
              }) => LoyaltySettingsCompanion.insert(
                id: id,
                rewardThreshold: rewardThreshold,
                staffPin: staffPin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoyaltySettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoyaltySettingsTable,
      LoyaltySettingRecord,
      $$LoyaltySettingsTableFilterComposer,
      $$LoyaltySettingsTableOrderingComposer,
      $$LoyaltySettingsTableAnnotationComposer,
      $$LoyaltySettingsTableCreateCompanionBuilder,
      $$LoyaltySettingsTableUpdateCompanionBuilder,
      (
        LoyaltySettingRecord,
        BaseReferences<
          _$AppDatabase,
          $LoyaltySettingsTable,
          LoyaltySettingRecord
        >,
      ),
      LoyaltySettingRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$LoyaltySettingsTableTableManager get loyaltySettings =>
      $$LoyaltySettingsTableTableManager(_db, _db.loyaltySettings);
}
