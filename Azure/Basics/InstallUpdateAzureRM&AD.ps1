##Run POSH Terminal as Administrator

#Install MSOnline PowerShell for Azure Active Directory (V1)
Install-Module -Name MSOnline
##Import Office 365 and Azure AD module
Import-Module -Name MSOnline

#Check Existing AzureRM module
$PSVersionTable.PSVersion


#Install AzureRM module
Install-Module -Name AzureRM

#Import AzureRM module
Import-Module -Name AzureRM

#Update Azure RM module to latest
Update-Module -Name AzureRM
Install-Module -Name AzureRM -Repository PSGallery -Force

#Import SharePoint Online module
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#Import Skype for Busines Online module
Import-Module SkypeOnlineConnector

#Import Azure classic module
#Only used with legacy deployments, not relevant to Azure CSP
Install-Module Azure



#For any updates, please refer to www.powershellgallery.com
#By Oaker Min (Bruce) Partner Enablement Specialist at rhipe.
