$workloads = "Microsoft.VisualStudio.Component.TestTools.CodedUITest"

# Set PowerShell execution policy
#Set-ExecutionPolicy RemoteSigned -Force

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install Chocolatey packages
#& choco install googlechrome -y
#& choco install poshgit -y
& choco install dotnet4.6.1 -y
#& choco install nodejs -y

$vs_EnterpriseUrl = "https://aka.ms/vs/15/release/vs_enterprise.exe"
$vs_Enterprise = "$($env:TEMP)\vs_Enterprise.exe"

Invoke-WebRequest $vs_EnterpriseUrl -OutFile $vs_Enterprise

$workloads.Split(",[ ]{0,1}") | ForEach-Object {
    
    $workloadArgs += "--add $($_) "
}

$workloadArgs += "--quiet --norestart --wait"
$workloadParams = $workloadArgs.Split(" ")
Start-Process $vs_Enterprise $workloadParams -Wait

refreshenv

#Start-Sleep -Seconds 60
#Restart-Computer