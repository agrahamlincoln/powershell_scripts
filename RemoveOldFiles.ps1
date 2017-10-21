# RemoveOldFiles
# This powershell script was created to purge files from a folder that are older than a specific date. The script will automatically remove files and also write a log of which files it deleted to a file in the same location.
Function GetChildFilesOlderThan
{
    Param ([string]$path, [int]$days = 0, [string]$name)
    Get-ChildItem -Path $path | Where-Object {$_.CreationTime -lt (Get-Date).AddDays($days) -and $_.Name -like $name }
}

Function PrePendFile
{
    Param([string]$path, $content)

    #check if exists
    if (Test-Path $path)
    {
        #read existing data
        $oldContent = Get-Content -Path $path
    }
    else 
    {
        $oldContent = ""
    }

    #overwrite old file with most recent content
    Out-File -FilePath $path -InputObject $content

    #write old content below newest content
    Add-Content -Path $path -Value $oldContent
}

# Path where files are to be pruned
$FilePath = ""
$FileName = "" # supports wildcards (i.e. '*-backup.tar.gz')
$MaxFileAge = # negative days (i.e. -60)

$OldFiles = GetChildFilesOlderThan $FilePath $MaxFileAge $FileName

if ($OldFiles.Count -gt 0)
{
    #Write Output to Logs
    PrePendFile $FilePath\RemoveOldFiles_Log.txt $OldFiles
    PrePendFile $FilePath\RemoveOldFiles_Log.txt (Get-Date)

    #Remove all the old files
    GetChildFilesOlderThan $FilePath $MaxFileAge $FileName | Remove-Item
}
