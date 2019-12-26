<# import some auxiliary functions #>
. .\functions.ps1

$global:config = loadConfigVariables
createFolders

$global:timestamp = Get-Date -Format 'yyyy-MM-dd_hh-mm-ss'
$global:logFile = $global:config.path_logs + "disable-mailboxes-" + $global:timestamp + ".log"

$files = loadMailboxesToDisable
if ([string]::IsNullOrEmpty($files)) {
    Write-Log "No mailboxes to disable"
    return;
}

if($files.count -lt 1) {
    Write-Log "No mailboxes to disable"
    return;
}

startPSSession
validatePSSession

Write-Log "$($files.count) files to process"
foreach ($element in $files) {
    $filePath = $global:config.path_disable_in + "\" + $element
    disableMailbox $filePath
}

