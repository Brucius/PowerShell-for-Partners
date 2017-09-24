##Run PowerShell ISE as Administrator

##Import Office 365 and Azure AD module
Import-Module MsOnline
#Install MSOnline PowerShell for Azure Active Directory (V1)
Install-Module -Name MSOnline

#Install AzureRM module
Install-Module -Name AzureRM

#Import AzureRM module
Import-Module -Name AzureRM
Import-Module -Name AzureRM.profile

#Import SharePoint Online module
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#Import Skype for Busines Online module
Import-Module SkypeOnlineConnector

#Import Azure Service Manager module
#Only used with legacy deployments, not relevant to Azure CSP
Install-Module Azure



#For any updates, please refer to www.powershellgallery.com
#By Oaker Min (Bruce) Partner Enablement Specialist at rhipe.
