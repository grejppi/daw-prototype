# $env:GITHUB_WORKSPACE = 'C:\Users\qbgee\Documents\Code\Aurora\Prototyping'

Set-Location $env:GITHUB_WORKSPACE
$installer_url = 'http://download.qt.io/official_releases/qt/5.13/5.13.2/qt-opensource-windows-x86-5.13.2.exe'
Invoke-WebRequest -Uri $installer_url -OutFile "qt-install.exe"
# .\qt-install.exe --script .\actions\installer-noninteractive-windows.qs --verbose