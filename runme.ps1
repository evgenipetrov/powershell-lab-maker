#requires -Version 3.0

# import lab maker module
$name = '{0}\Module\LabMaker' -f $PSScriptRoot
Import-Module -Name $name -Force -Verbose


$inventoryFile = '{0}\inventory.csv' -f $PSScriptRoot

# provision lab
New-Lab -InventoryFile $inventoryFile