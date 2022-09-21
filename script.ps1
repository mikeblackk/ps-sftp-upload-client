# Connects to SFTP endpoint and uploads the latest file in the folder - Documentation: https://winscp.net/eng/docs/start

# Load WinSCP .NET assembly - use netstandard2.0 for Powershell > 5 as it will throw an error.
# Download the WinSCP and extract to same folder where the script will run as it is required for the SFTP client Link: https://winscp.net/eng/downloads.php and select ".NET assembly / COM library"

# Extracted client to WinSCP folder in root folder of script

Add-Type -Path (Join-Path $PSScriptRoot "WinSCP/netstandard2.0/WinSCPnet.dll")

# Session Variables
$SFTPServer = ""
$SFTPUserName = ""
# Leave password as "" if using public key authenication
$SFTPPassword = ""
# Only PPK is supported with WinSCP - use puttygen client to convert private key to ppk
$PrivateKey = "" # <enter full path to ppk>
# Local folder for CSV data - <full path to folder>
$localPath = ""
# Folder on SFTP Server - <remote path folder (optional)
$remotePath = ""
# Hostkey Fingerprint - update as required
$HostKeyFingerprint = "ssh-rsa 2048 9RZ6xnmlAPowufGr+ft0QhaqesrGTSOcxtZa0Mhdf9o"

# Setup the session object to be instanisated, private key auth is being used and ensure public key is setup on the server

$sessionOptions = New-Object WinSCP.SessionOptions 
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.HostName = $SFTPServer
$sessionOptions.UserName = $SFTPUserName
$sessionOptions.Password = $SFTPPassword
$sessionOptions.SshPrivateKeyPath = $PrivateKey
$sessionOptions.SshHostKeyFingerprint = $HostKeyFingerprint 

# Transfer options to ignore preserving timestamps as S3 will throw an error.

$transferOptions = New-Object WinSCP.TransferOptions
$transferOptions.FilePermissions = $Null # This is default
$transferOptions.PreserveTimestamp = $false

$session = New-Object WinSCP.Session

try
{
    # Connect
    $session.Open($sessionOptions)

    # Select the most recent file.
    # The !$_.PsIsContainer test excludes subdirectories.
    # With PowerShell 3.0, you can replace this with -File switch of Get-ChildItem. 
    $latest =
        Get-ChildItem -Path $localPath |
        Where-Object {!$_.PsIsContainer} |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    # Any file at all?
    if ($latest -eq $Null)
    {
        Write-Host "No file found"
        exit 1
    }
    # Upload the selected file
    $session.PutFiles(
        [WinSCP.RemotePath]::EscapeFileMask($latest.FullName),
        [WinSCP.RemotePath]::Combine($remotePath, "*"), $False, $transferOptions).Check()
}
finally
{
    # Disconnect, clean up
    $session.Dispose()
}

exit 0

catch
{
Write-Host "Error: $($_.Exception.Message)"
exit 1
<<<<<<< HEAD
}
=======
}
>>>>>>> b14a0c54d2e0919809c3fa66f753e9d222d336ac
