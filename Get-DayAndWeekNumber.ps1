Function Get-WeekNumber {
    $WeekNum = get-date -UFormat %V
    Write-Output "Week Number $WeekNum"
}

Function Get-DayNumber {
	$dayOfYear = $(Get-Date).DayOfYear    
    Write-Output "Day Number $dayOfYear"
    Get-WeekNumber
}