$opt = New-PSSessionOption -SkipCACheck -SkipCNCheck
$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://18.231.90.94/powershell/ -Credential wso2training.com\joaoemilio -Authentication Digest -SessionOption $opt -AllowRedirection
Import-PSSession $s


$files = @(Get-ChildItem -Path 'C:\temp\enable\in\*.json')
foreach ($element in $files) {
    $json = Get-Content $element | Out-String | ConvertFrom-Json

    if (-not ([string]::IsNullOrEmpty($json.identity.trim()))) {
        $identity = Get-Mailbox $json.identity 
        #verify if identity exists    
        $alias = write-output ($identity | Select -ExpandProperty "Alias")
        if (-not ([string]::IsNullOrEmpty($alias))) {
            Write-Output $alias
        } else {
            Write-Output "There isn't a mailbox associated"
        }
    } else {
        Write-Output "json.identity is null or empty"
    }

}