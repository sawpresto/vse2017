# Set PowerShell execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install Chocolatey packages
& choco install googlechrome -y
& choco install poshgit -y
& choco install dotnet4.6.1 -y
& choco install windowsazurepowershell -y
& choco install visualstudio2017-installer -y
& choco install visualstudio2017enterprise --version 15.2.26430.20170605 --package-parameters "--passive --locale en-US" -y
& choco install visualstudio2017-workload-netweb -y
refreshenv