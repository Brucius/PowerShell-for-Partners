#For Further Updates on IP Changes of Azure KMS Service please visit
#https://blogs.technet.microsoft.com/jpaztech/2016/05/16/azure-vm-may-fail-to-activate-over-expressroute/

Login-AzureRmAccount

#Get information on the virtual network
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName "ResourceGroup" -Name "VNet"

#Create a new route table and define the route
$RouteTable = New-AzureRmRouteTable -Name "RouteTableName" -ResourceGroupName "ResourceGroup" -Location "Southeast Asia"

Add-AzureRmRouteConfig -Name "KMSActivate" -AddressPrefix 23.102.135.246/32 -NextHopType Internet -RouteTable $RouteTable
Set-AzureRmRouteTable -RouteTable $RouteTable

#Apply the route defined above to the subnet
$forcedTunnelVNet = $vnet.Subnets | ? Name -eq "Subnet-Name"
$forcedTunnelVNet.RouteTable = $RouteTable
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
