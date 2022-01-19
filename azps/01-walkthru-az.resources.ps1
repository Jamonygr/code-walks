# UP NEXT: Work with Resource Groups
Get-Command -Module Az.Resources
Get-Command -Module Az.Resources | Group-Object -Property Noun | Sort-Object -Property Count -Descending


#region AZRESOURCEGROUP
# test creating something with a default
New-AzResourceGroup -Name "$($MySettings.NamePrefix)-rg" -Location $MySettings.Region


#endregion



# MANAGEMENT GROUPS
Get-Command *AzManagementGroupDeployment*
Get-Help New-AzManagementGroupDeployment -Examples

# DEPLOYMENTS

# APPLICATIONS
## managed applications


# SERVICE PRINCPALS

# RESOURCES
# ./project-resource-inventory.ps1

# POLICIES

# ROLES

# USERS

# GROUPS

# TAGS

Get-AzResourceGroup