#requires -version 5
#Requires -PSEdition Desktop
Invoke-WindowsToastNotification {
	Param(
		[string]$ToastTitle,
		[string]$ToastMessage
	)

	$xml = @"
	<toast>
	  
	  <visual>
		<binding template="ToastGeneric">
		  <text>$ToastTitle</text>
		  <text>$ToastMessage</text>
		</binding>
	  </visual>

	  <audio silent="true"/>
	  
	</toast>
"@
	
	$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
	$XmlDocument.loadXml($xml)
	$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)

}
