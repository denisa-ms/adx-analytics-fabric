# Connect-AzAccount
# Subscription id of the current subscription
$subscriptionId=$(az account show --query id --output tsv)
$resourceGroupName = "adx-fabric-rg1"
$location = "westeurope"


# Set subscription 
Set-AzContext -SubscriptionId $subscriptionId 
# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile deployAll.bicep -WarningAction:SilentlyContinue
