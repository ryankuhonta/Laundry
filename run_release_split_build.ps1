$ErrorActionPreference = 'Continue'
Set-Location 'C:\Dev\Laundry Loyalty Program'
$env:DART_SUPPRESS_ANALYTICS = 'true'
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
C:\src\flutter\bin\flutter.bat build apk --release --split-per-abi --verbose *> .\release-build.out.log
exit $LASTEXITCODE
