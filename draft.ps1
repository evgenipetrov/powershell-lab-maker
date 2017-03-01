<# 

connect

new-azurevm

new-azurestorage // filesharetype

azcopy file to storage

copy file from storage to VM vhd or create a new vhd and copy the files there. attach the vhd to the VM.

#>

# connect to azure
# Login-AzureRmAccount

$location = "westeurope"
$resourceGroup = "AzurePowerShell1"
$storageAccountName = "evgenistorageaccount1"
$storageAccountSkuName = "Standard_LRS"
$storageAccountKind = "Storage"

$vmSize = "Standard_A0"

$user = "evgeni"
$pass = 'Welcome.2017!'



# create a new resource group to hold our new resources

try{
Get-AzureRmResourceGroup -Name $resourceGroup -ErrorAction Stop
} 
catch {
New-AzureRmResourceGroup -Name $resourceGroup -Location $location
}

# check storage account availability and create the storage account

$storageAccountAvailability = Get-AzureRmStorageAccountNameAvailability $storageAccountName
if($storageAccountAvailability.NameAvailable -ne "True"){
    #break
}

$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -SkuName $storageAccountSkuName -Kind $storageAccountKind -Location $location

$storageAccount = get-azurermstorageaccount -name $storageaccountname -resourcegroupname $resourceGroup

# create network
$mySubnet = New-AzureRmVirtualNetworkSubnetConfig -Name "mySubnet" -AddressPrefix 10.0.0.0/24
$myVnet = New-AzureRmVirtualNetwork -Name "myVnet" -ResourceGroupName $resourceGroup -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $mySubnet
$myPublicIp = New-AzureRmPublicIpAddress -Name "myPublicIp" -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic
$myNIC = New-AzureRmNetworkInterface -Name "myNIC" -ResourceGroupName $resourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id

# create the virtual machine

$secPasswd = ConvertTo-SecureString -String $pass -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential ($user, $secpasswd)

$myVM = New-AzureRmVMConfig -VMName "myVM" -VMSize $vmSize

$myVM = Set-AzureRmVMOperatingSystem -VM $myVM -Windows -ComputerName "myVM" -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

 $myVM = Set-AzureRmVMSourceImage -VM $myVM -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"

 $myVM = Add-AzureRmVMNetworkInterface -VM $myVM -Id $myNIC.Id

 $blobPath = "vhds/myOsDisk1.vhd"
 $osDiskUri = $storageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath

 $myVM = Set-AzureRmVMOSDisk -VM $myVM -Name "myOsDisk1" -VhdUri $osDiskUri -CreateOption fromImage

  New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $myVM


