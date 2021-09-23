#Gestion des serveurs a distance by GKUHN for CONFORAMA on 04/11/2020

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
 
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information'
    )
 
    [pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $Message
        Severity = $Severity
    } | Export-Csv -Path $log -Append -NoTypeInformation
 }


$Serveurs = (get-adcomputer -filter * -searchbase "OU=Serveurs,DC=fr,DC=conforama,DC=grp").name | sort-object -Property Name
$log = "D:\Scripts\GestDist\Sortie\TestWinRMConnection.csv"

# Module PowerShell Active Directory requis
Import-Module ActiveDirectory

foreach ( $serveur in $serveurs)
{
try{
invoke-command -computername $serveur {1} -ErrorAction Stop
Write-Log -Message "$serveur OK" -Severity  Information
}catch{
Write-Log -Message "$serveur NOK" -Severity  Error
}
}