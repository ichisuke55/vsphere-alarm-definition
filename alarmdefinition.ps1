Connect-VIServer -Server $SERVER -User $USERNAME -Password $PASSWORD

# get English AlarmDefinition
$enAlarmDefinitions = Get-AlarmDefinition

# locale change
$si = get-view ServiceInstance
$sm = Get-View $si.Content.SessionManager
$sm.SetLocale("ja")

# get Japanese AlarmDefinition
$jpAlarmDefinitions = Get-AlarmDefinition

$csvData = @()
foreach ($enAlarmDefinition in $enAlarmDefinitions) {
    foreach ($jpAlarmDefinition in $jpAlarmDefinitions) {
        if ($enAlarmDefinition.ExtensionData.Info.SystemName -eq $jpAlarmDefinition.ExtensionData.Info.SystemName) {
            $alarmAction = Get-AlarmAction -AlarmDefinition $enAlarmDefinition

            $systemName = $enAlarmDefinition.ExtensionData.Info.SystemName
            $nameEN = $enAlarmDefinition.Name
            $nameJP = $jpAlarmDefinition.Name
            $description = $jpAlarmDefinition.Description
            $enabled = $enAlarmDefinition.Enabled

            $csvDataEntry = New-Object PSObject -Property @{
                'ID' = $alarmId
                'SystemName' = $systemName
                'Name_EN' = $nameEN
                'Name_JP' = $nameJP
                'Description' = $description
                'Enabled' = $enabled
                'ActionType' = $alarmAction.ActionType
            }
            $csvData += $csvDataEntry
        }
    }
}

$csvData | Export-Csv -Path "AlarmDefinitions.csv" -NoTypeInformation -encoding UTF8

Disconnect-VIServer -Confirm:$false

