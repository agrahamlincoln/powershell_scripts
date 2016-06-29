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

$FilePath = "F:\NGProd Backup\Transaction Log"
$MaxFileAge = -60
$FileName = "NGProd_backup_*"
$OldFiles = GetChildFilesOlderThan $FilePath $MaxFileAge $FileName

if ($OldFiles.Count -gt 0)
{
    #Write Output to Logs
    PrePendFile $FilePath\RemoveOldFiles_Log.txt $OldFiles
    PrePendFile $FilePath\RemoveOldFiles_Log.txt (Get-Date)

    #Remove all the old files
    GetChildFilesOlderThan $FilePath $MaxFileAge $FileName | Remove-Item
}
