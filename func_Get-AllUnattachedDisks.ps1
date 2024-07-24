function Get-AllUnattachedDisks {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]  [String]$Export_CSV_path
    )
    
    ##Initiate array variable
    $results = @()
    
    ##Connect to Azure Account
    Write-Verbose "Connecting to Azure..."
    $context = Get-AzContext  
    if (!$context) {  
        Connect-AzAccount | Out-Null
    }
    
    ##Get a list of ALL Azure subscription the connected account has access to
    $subs = Get-AzSubscription | Select-Object Name, Id
    
    
    foreach ($sub in $subs) {
        ##Set current connection context to one of the azure subscriptions
        Write-Verbose "Setting Azure connection to $subscriptionName subscription."
        Set-AzContext -Subscription $sub.name | Out-Null
    
        ##Get a list of all Azure Disks in the subscription
        $disks = Get-AzDisk
    
        ##Build array of disk properties plus subscription name for each disk that 
        foreach ($disk in $disks) {
            if ($null -eq $disk.ManagedBy) {
                $myObject = [PSCustomObject]@{
                    Name              = $disk.Name
                    ResourceGroupName = $disk.ResourceGroupName
                    TimeCreated       = $disk.TimeCreated
                    OsType            = $disk.OsType
                    Id                = $disk.Id
                    SubscriptionName  = $sub.name
                }
                $results += $myObject
            }
        }
    }

    ##Check if Export_CSV_path variable ends with a \, if not add it
    if ($Export_CSV_path -notmatch '\\$') {
        $Export_CSV_path += '\'
    }
    ##Check if the provided path in Export_CSV_path variable exists, if not create it
    if (!(Test-Path -Path $Export_CSV_path)) { 
        New-Item -ItemType "directory" -Path $Export_CSV_path 
    }
    ##Create CSV filename based on date
    $date = (Get-Date -format "MM-dd-yyyy-HH-mm-ss")
    $FileName = $Export_CSV_path + 'allUnattachedAzureDisks_' + "$date.csv"
    
    ##Export to CSV
    $results | Export-Csv -NoTypeInformation -Path $Filename

}
