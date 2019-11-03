$config = Get-Content 'config.json' | Out-String | ConvertFrom-Json

$path = $config.path_enable_in + "\*.json"
$timestamp = Get-Date -Format 'yyyy-MM-dd_hh-mm-ss'   

function Write-Log {
    Param( $Message )
    $logFile = $config.path_logs + "enable-mailboxes-" + $timestamp + ".log"
    Write-Output $logFile
    if ( -not (Test-Path -Path $config.path_logs -PathType Container) ) {
        New-Item -ItemType "directory" -Path $config.path_logs
    }

    $timestamp = Get-Date -Format 'yyyy-MM-dd hh:mm:ss'

    "[$timestamp] $Message" | Tee-Object -FilePath $logFile -Append | Write-Verbose
}

Write-Log "Retrieving requests"
$files = @(Get-ChildItem -Path $path)
if($files.count -lt 1) {
    Write-Log "No mailboxes to enable"
    return;
}

Write-Log "$($files.count) files to process"
Write-Log "Creating PowerShell Session"
$opt = New-PSSessionOption -SkipCACheck -SkipCNCheck
#$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $config.exchange_server_uri -Credential $config.admin -Authentication Digest -SessionOption $opt -AllowRedirection
Write-Log "Importing PowerShell Session"
Import-PSSession $s
Write-Log "Validating PowerShell Session"
$validation = Get-Mailbox 
Write-Output $validation 
if ( -not (Test-Path -Path $config.path_enable_out -PathType Container) ) {
    New-Item -ItemType "directory" -Path $config.path_enable_out
}

if ( -not (Test-Path -Path $config.path_disable_out -PathType Container) ) {
    New-Item -ItemType "directory" -Path $config.path_disable_out
}

foreach ($element in $files) {
    $json = Get-Content $element | Out-String | ConvertFrom-Json
    Write-Log $element.name 

    if (-not ([string]::IsNullOrEmpty($json.identity))) {
        $identity = Get-Mailbox $json.identity 
        #verify if identity exists    
        $alias = write-output ($identity | Select -ExpandProperty "Alias")
        if (-not ([string]::IsNullOrEmpty($alias))) {
            Write-Log $alias
        } else {
            Write-Log "There isn't a mailbox associated"
            $enable = Enable-Mailbox $json.identity 
        }
    } else {
        Write-Log "json.identity is null or empty"
    }
    Move-Item -Path $element -Destination $config.path_enable_out

}

