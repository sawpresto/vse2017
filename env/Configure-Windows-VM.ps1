param
(
    [string]$workloads = "Microsoft.VisualStudio.Component.TestTools.CodedUITest,Microsoft.VisualStudio.Component.TestTools.WebLoadTest,Microsoft.VisualStudio.Component.TestTools.Core,Microsoft.VisualStudio.Workload.Azure;includeRecommended,Microsoft.VisualStudio.Workload.NetWeb;includeRecommended;includeOptional,Microsoft.VisualStudio.Workload.Data;includeRecommended,Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended;includeOptional,Microsoft.VisualStudio.Workload.NetCoreTools"
)

# Set PowerShell execution policy
#Set-ExecutionPolicy RemoteSigned -Force

$vs_EnterpriseUrl = "https://aka.ms/vs/15/release/vs_enterprise.exe"
$vs_Enterprise = "C:\Windows\Temp\vs_Enterprise.exe"

Invoke-WebRequest $vs_EnterpriseUrl -OutFile $vs_Enterprise

$workloads.Split(",[ ]{0,1}") | ForEach-Object {
    
    $workloadArgs += "--add $($_) "
}

$workloadArgs += "--quiet --norestart --wait"
$workloadParams = $workloadArgs.Split(" ")
Start-Process $vs_Enterprise $workloadParams -Wait

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install Chocolatey packages
& choco install googlechrome -y
& choco install firefox -y
& choco install poshgit -y
& choco install nodejs -y

refreshenv

#Start-Sleep -Seconds 60
#Restart-Computer