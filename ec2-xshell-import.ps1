#Import AWS credentials
. ./credentials.ps1

$regions = @("us-east-1","us-west-1")
$instances = @()

$regions | ForEach-Object {
    $instances += (Get-EC2Instance -Region $_).Instances
}

$sessions = @()
$instances | ForEach-Object {
    $sessions += New-Object PSObject -Property @{
        'Name'=$_.Tags.Value;
        'Host'=$_.PublicIpAddress;
        'Protocol'='SSH';
        'Port'='22';
    }
}

$sessions | ForEach-Object {
    $csvline += "$($_.Name),$($_.Host),$($_.Protocol),$($_.Port)`n"
}

$csvline | Out-File ./sessions.csv