<powershell>
# WinRM configuration - Machine would listen to port 5986
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file

# Installation of OpenSSH - till the end of this script
New-Item -ItemType directory "C:\ZipFolder\"

# Assigning variables - URL to download OpenSSH into the ZipFile folder and extract into destiation folder
$url = 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip'
$ZipFile = 'C:\ZipFolder\' + $(Split-Path -Path $url -Leaf)
$Destination= 'C:\Program Files\'

# Below command is to avoid the TLS/SSL error when 'Invoke-WebRequest' command is executed
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile $ZipFile

# Extracting the zip file and copying it to the destination folder
$ExtractShell = New-Object -ComObject Shell.Application
$Files = $ExtractShell.Namespace($ZipFile).Items()
$ExtractShell.NameSpace($Destination).CopyHere($Files)

# Running the install-sshd powershell script to install SSH
Set-Location 'C:\Program Files\OpenSSH-Win64\'
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1

# Allowing all inbound ssh traffic - port 22 
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Starting both SSH server and SSH agent
net start sshd
net start ssh-agent
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic

# Deleting the temporary folder created
Remove-Item –path C:\ZipFolder\ –recurse

# Making powershell as the default shell type for SSH server
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# Restart the SSH service
Restart-Service -Name sshd, ssh-agent -Force
</powershell>
