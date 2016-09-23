## Run PowerShell ISE as Administrator

## Import Office 365 and Azure AD module
Import-Module MsOnline

## Import SharePoint Online module
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

## Import Skype for Busines Online module
Import-Module SkypeOnlineConnector

## Import Azure Resouce Manager module
Install-Module AzureRM

## Import Azure Service Manager module
## Only used with legacy deployments, not relevant to Azure CSP
Install-Module Azure
