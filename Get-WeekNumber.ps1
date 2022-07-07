Function Get-WeekNumber {
    $WeekNum = get-date -UFormat %V
    Write-Output "Week Number $WeekNum"
}