<h1><b>Powershell SFTP Client</b></h1>

A PowerShell script that uses WinSCP object library to enable uploading of the latest file in a directory to a SFTP server.

<h2>Guide</h2>

This is for Windows based operating systems only. If using linux, you will need to create the script as a bash with SSH.

1. Powershell script creates a WinSCP object to enable a session to be created to upload files to a remote server. WinSCP is required for this script to run and can be downloaded at https://winscp.net/eng/download.php
2. Download ".NET assembly / COM library" and extract to location where the script will be stored
3. Modify the following parameters within script.ps1:
    - Update path for "Add-Type -Path (Join-Path $PSScriptRoot "pathtofile/WinSCPnet.dll")"
    - $SFTPServer -endpoint hostname
    - $SFTPUserName - username for SFTP authetication
    - $PrivateKey - if using pub key authentication
    - $localPath - full path to folder for uploading files eg. C:/Files/
    - $remotePath - path on remote server to upload, if none leave as ""
4. Ensure you that use netstandard2.0 WinSCPnet.dll otherwise the script will not run as it is required to create the required .NET objects SFTP client
5. Create a scheduled task on the server/workstation with the desired schedule.

The script will check the folder specified for the latest file created and use that as the file to upload to the remote location.

All documentation for WinSCP is <a href="https://winscp.net/eng/docs/library_from_script"> here </a>

Tested with AWS SFTP managed server with managed credentials created within the server. Uploaded public key to the service when creating the user.
