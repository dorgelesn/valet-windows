$phpUrl = "http://windows.php.net/downloads/releases/php-7.1.5-nts-Win32-VC14-x86.zip"
$phpIniUrl = "https://raw.githubusercontent.com/cretueusebiu/valet-windows/master/cli/stubs/php.ini"
$caCertUrl = "https://curl.haxx.se/ca/cacert.pem"
$zipfile = "$PSScriptRoot\php.zip"
$outpath = "C:\php"

Import-Module BitsTransfer
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (Get-Command "php" -errorAction SilentlyContinue) {
    Write-Output "PHP already installed!"
    exit
}

# Download zip file
Start-BitsTransfer -Source $phpUrl -Destination $zipfile -Description " " -DisplayName "Downloading PHP..."

# Extract zip file
Write-Output "Installing PHP...`n"
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
Remove-Item $zipfile

# Download php.ini
Start-BitsTransfer -Source $phpIniUrl -Destination $outpath\php.ini -Description " " -DisplayName "Installing php.ini..."

# Download CA certificate
Start-BitsTransfer -Source $caCertUrl -Destination $outpath\cacert.pem -Description " " -DisplayName "Installing CA certificate..."

# Add PHP to the environment variable
$env:Path += ";" + $outpath
[Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)

# Done
Write-Output "PHP installed successfully!`n"
php -v
