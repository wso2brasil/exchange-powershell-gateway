<# import some auxiliary functions #>
. .\functions.ps1

$global:config = loadConfigVariables
createOutFolders

$global:timestamp = Get-Date -Format 'yyyy-MM-dd_hh-mm-ss'
$global:logFile = $global:config.path_logs + "enable-mailboxes-" + $global:timestamp + ".log"

$files = loadFiles
if ([string]::IsNullOrEmpty($files)) {
    Write-Log "No mailboxes to enable"
    return;
}

if($files.count -lt 1) {
    Write-Log "No mailboxes to enable"
    return;
}

startPSSession
validatePSSession

Write-Log "$($files.count) files to process"
foreach ($element in $files) {
    $filePath = $global:config.path_enable_in + "\" + $element
    enableMailbox $filePath
}

