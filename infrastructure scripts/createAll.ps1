# Connect-AzAccount
# Subscription id of the current subscription
$subscriptionId="<add your subscription id here>"
$resourceGroupName = "adx-fabric-rg"
$location = "westeurope"


# Set subscription 
Set-AzContext -SubscriptionId $subscriptionId 
# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile deployAll.bicep -WarningAction:SilentlyContinue
