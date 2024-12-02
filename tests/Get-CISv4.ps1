Import-Module ./monkey365
$param = @{
    ClientId = '89ae29c1-f952-4cc9-912e-c00d4e0bc7ea';
    TenantID = 'c65cda98-dce8-41fa-9b2f-2776176649ef';
    CertFilePassword = ('****' | ConvertTo-SecureString -AsPlainText -Force);
    certificate = 'CIS.pfx';
    Instance = 'Microsoft365';
    IncludeEntraID = $true;
    Collect = @("AdminPortal","ExchangeOnline","MicrosoftTeams","Purview","SharePointOnline");
    ExportTo = @("JSON","HTML");
    RuleSet = 'rules/rulesets/cis_m365_4.0.json';
}
$assets = Invoke-Monkey365 @param #-Verbose