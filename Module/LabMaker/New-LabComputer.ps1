function New-LabComputer
{
  param
  (
    [String]
    [Parameter(Mandatory)]
    $GroupName,
  
    [String]
    $InternalNetworkName,
  
    [String]
    $ExternalNetworkName,
  
    [String]
    $LabComputerName,
  
    [String]
    $LabDomainName,
  
    [String]
    $LabComputerInternalAddress,
  
    [String]
    $LabComputerTemplateName

  )
}