function New-Lab{
  <#
    .SYNOPSIS
    A master script that provisions a new lab environment.

    .DESCRIPTION
    A master script that reads a scv inventory file and provisions lab computers as per the objects in the csv file.

    .PARAMETER InventoryFile
    specify the location to the inventory csv file

    .PARAMETER Location
    specify location to deploy virtual machine files

    .PARAMETER Name
    specify lab name to group the virtual machines 

    .EXAMPLE
    New-Lab -InventoryFile Value -Location Value -Name Value
    Describe what this call does

    .NOTES
    this is a constant work in progress. expect it to break often.
  #>


    param
    (
      [String]
      [Parameter(Mandatory=$true,HelpMessage='Please specify path to the inventory csv file')]
      $InventoryFile,
      
      [string]
      [Parameter(Mandatory=$true,HelpMessage='Please specify a location to deploy the lab vm files')]
      $Location,
      
      [string]
      [Parameter(Mandatory=$true,HelpMessage='Please specify a lab name')]
      $Name
    )

    $inventory = Get-Content -Path $InventoryFile | ConvertFrom-Csv
    
    # make directory for the lab files
    $labLocation = New-Item -Path $Location -Name $Name -ItemType Directory

    foreach ($item in $inventory)
    {
      New-LabComputer -InternalNetworkName $item.InternalNetworkName `
                      -ExternalNetworkName $item.ExternalNetworkName `
                      -LabComputerName $item.LabComputerName `
                      -LabDomainName $item.LabDomainName `
                      -LabComputerInternalAddress $item.InternalNetAddress `
                      -LabComputerTemplateName $item.LabComputerTemplateName
    }
    

}