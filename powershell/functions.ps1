function loadConfigVariables {    
    <# load config file #>
    $_config = Get-Content 'config.json' | Out-String | ConvertFrom-Json
    return $_config
}

function createFolders {    
    <# create folders to move files processed if they don't exist #>
    if ( -not (Test-Path -Path $global:config.path_enable_out -PathType Container) ) {
        New-Item -ItemType "directory" -Path $global:config.path_enable_out
    }

    if ( -not (Test-Path -Path $global:config.path_disable_out -PathType Container) ) {
        New-Item -ItemType "directory" -Path $global:config.path_disable_out
    }

    if ( -not (Test-Path -Path $global:config.path_logs -PathType Container) ) {
        New-Item -ItemType "directory" -Path $global:config.path_logs
    }

}

function loadFiles {
    Write-Log "Retrieving requests"
    $path = $global:config.path_enable_in
    $files = @(Get-ChildItem -Path $path)
    return $files
}

function loadMailboxesToDisable {
    Write-Log "Retrieving requests to disable mailboxes"
    $path = $global:config.path_disable_in
    $files = @(Get-ChildItem -Path $path)
    return $files
}

function startPSSession {
    <# Initiate session to start processing #>
    $opt = New-PSSessionOption -SkipCACheck -SkipCNCheck
    $s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $global:config.exchange_server_uri -Credential $global:config.admin -Authentication Digest -SessionOption $opt -AllowRedirection

    Write-Log $global:config "Importing PowerShell Session"
    Import-PSSession $s    
}

function validatePSSession {
    Write-Log "Validating PowerShell Session"
    $validation = Get-Mailbox joaoemilio
    Write-Output $validation     
}

function enableMailbox( $file ) {
    $json = Get-Content $file | Out-String | ConvertFrom-Json
    Write-Log $file

    if (-not ([string]::IsNullOrEmpty($json.identity))) {
        $identity = Get-Mailbox $json.identity 
        #verify if identity exists    
        $alias = write-output ($identity | Select -ExpandProperty "Alias")
        if (-not ([string]::IsNullOrEmpty($alias))) {
            $msg = $alias + " already has a mailbox enabled"
            Write-Log $msg
        } else {
            $msg = "Enabling mailbox for " + $json.identity
            Write-Log $msg 
            $enable = Enable-Mailbox $json.identity 
            Write-Log $enable 
        }
    } else {
        Write-Log "json.identity is null or empty"
    }
    Move-Item -Path $file -Destination $global:config.path_enable_out
}

function disableMailbox( $file ) {
    $json = Get-Content $file | Out-String | ConvertFrom-Json
    Write-Log $file

    if (-not ([string]::IsNullOrEmpty($json.identity))) {
        $identity = Get-Mailbox $json.identity 
        #verify if identity exists    
        $alias = write-output ($identity | Select -ExpandProperty "Alias")
        if (-not ([string]::IsNullOrEmpty($alias))) {
            $msg = "Disabling mailbox for " + $json.identity
            Write-Log $msg 
            $disable = Disable-Mailbox $json.identity -Confirm:$false
            Write-Log $disable 
        } else {
            $msg = $alias + " doesn't has a mailbox enabled"
            Write-Log $msg
        }
    } else {
        Write-Log "json.identity is null or empty"
    }
    Move-Item -Path $file -Destination $global:config.path_disable_out
}


<#
Auxiliary function to write log messages 
#>
function Write-Log ( $Message ) {
    "[$timestamp] $Message" | Tee-Object -FilePath $global:logFile -Append | Write-Verbose
}