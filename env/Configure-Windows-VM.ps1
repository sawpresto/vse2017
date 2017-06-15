param
(
    [string]$workloads = "Microsoft.VisualStudio.Component.TestTools.CodedUITest,Microsoft.VisualStudio.Component.TestTools.WebLoadTest,Microsoft.VisualStudio.Component.TestTools.Core,Microsoft.VisualStudio.Workload.Azure;includeRecommended,Microsoft.VisualStudio.Workload.NetWeb;includeRecommended;includeOptional,Microsoft.VisualStudio.Workload.Data;includeRecommended,Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended;includeOptional,Microsoft.VisualStudio.Workload.NetCoreTools"
)

# Set PowerShell execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install certificates
& certmgr -add -c certificates\manifestSignCertificates.p12 -n "Microsoft Code Signing PCA 2011" -s -r LocalMachine CA
& certmgr -add -c certificates\manifestSignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root
& certmgr -add -c certificates\manifestCounterSignCertificates.p12 -n "Microsoft Time-Stamp PCA 2010" -s -r LocalMachine CA
& certmgr -add -c certificates\manifestCounterSignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root
& certmgr -add -c certificates\vs_installer_opc.SignCertificates.p12 -n "Microsoft Code Signing PCA" -s -r LocalMachine CA
& certmgr -add -c certificates\vs_installer_opc.SignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root

refreshenv

# Install Chocolatey packages
& choco install googlechrome -y
& choco install poshgit -y
& choco install dotnet4.6.1 -y
& choco install nodejs -y

$vs_EnterpriseUrl = "https://aka.ms/vs/15/release/vs_enterprise.exe"
$vs_Enterprise = "$($env:TEMP)\vs_Enterprise.exe"

Invoke-WebRequest $vs_EnterpriseUrl -OutFile $vs_Enterprise

$workloads -split ",[ ]{0,1}" | ForEach-Object {
    
    $workloadArgs += "--add $($_) "
}

$workloadArgs += "--passive --norestart --wait"
$workloadParams = $workloadArgs.Split(" ")
Start-Process $vs_Enterprise $workloadParams -Wait

refreshenv

Start-Sleep -Seconds 60
Restart-Computer