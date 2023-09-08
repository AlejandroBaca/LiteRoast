$ResultPageSize = 200
$SearchScope = 'Subtree'

$SearchString = 'LDAP://'
$Domain = '<client domain goes here>'
$DN = "DC=$($Domain.Replace('.', ',DC='))"
$SearchString += $DN
$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
$Searcher.CacheResults = $False
$Searcher.ReferralChasing = [System.DirectoryServices.ReferralChasingOption]::All
$Searcher

$Filter = '(&(objectClass=user)(servicePrincipalName=*))'
$Searcher.filter = $Filter
$Results = $Searcher.FindAll()

$OutputPath = "<output path for file>"

$Results | Where-Object {$_} | ForEach-Object {
    $spnString = ($($_.properties.serviceprincipalname) -join "`r`n").Trim()
    $CsvOutput = [PSCustomObject]@{spn=$spnString;whenchanged=$($_.properties.whenchanged)}
    $CsvOutput | Export-Csv -Path $OutputPath -NoTypeInformation -Append
}
