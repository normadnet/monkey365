﻿# Monkey365 - the PowerShell Cloud Security Tool for Azure and Microsoft 365 (copyright 2022) by Juan Garrido
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


function Get-MonkeyAzSecCenterBuiltin {
<#
        .SYNOPSIS
		Azure Collector to get Microsoft Defender for Cloud Builtin

        .DESCRIPTION
		Azure Collector to get Microsoft Defender for Cloud Builtin

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyAzSecCenterBuiltin
            Version     : 1.0

        .LINK
            https://github.com/silverhack/monkey365
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false,HelpMessage = "Background Collector ID")]
		[string]$collectorId
	)
	begin {
		#Collector metadata
		$monkey_metadata = @{
			Id = "az00103";
			Provider = "Azure";
			Resource = "DefenderForCloud";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyAzSecCenterBuiltin";
			ApiType = "resourceManagement";
			description = "Collector to get Microsoft Defender for Cloud Builtin";
			Group = @(
				"DefenderForCloud"
			);
			Tags = @(

			);
			references = @(
				"https://silverhack.github.io/monkey365/"
			);
			ruleSuffixes = @(
				"az_asc_builtin_policies"
			);
			dependsOn = @(

			);
			enabled = $true;
			supportClientCredential = $true
		}
		#Get Environment
		$Environment = $O365Object.Environment
		#Get Azure RM Auth
		$rm_auth = $O365Object.auth_tokens.ResourceManager
		#get Config
		$azure_auth_config = $O365Object.internal_config.ResourceManager | Where-Object { $_.Name -eq "azureAuthorization" } | Select-Object -ExpandProperty resource
	}
	process {
		$msg = @{
			MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Microsoft Defender for Cloud BuiltIn",$O365Object.current_subscription.displayName);
			callStack = (Get-PSCallStack | Select-Object -First 1);
			logLevel = 'info';
			InformationAction = $InformationAction;
			Tags = @('AzureSecCenterInfo');
		}
		Write-Information @msg
		#List Microsoft Defender for Cloud Bulletin
		$params = @{
			Authentication = $rm_auth;
			Provider = $azure_auth_config.Provider;
			ObjectType = "policyAssignments/SecurityCenterBuiltIn";
			Environment = $Environment;
			ContentType = 'application/json';
			Method = "GET";
			APIVersion = "2019-01-01";
		}
		$security_center_builtin = Get-MonkeyRMObject @params
		$acs_entries = @()
		foreach ($acs_entry in $security_center_builtin.Properties.parameters.PSObject.Properties) {
			$Unit_Policy = New-Object -TypeName PSCustomObject
			$Unit_Policy | Add-Member -Type NoteProperty -Name PolicyName -Value $acs_entry.Name.ToString()
			$Unit_Policy | Add-Member -Type NoteProperty -Name Status -Value $acs_entry.value.value.ToString()
			$Unit_Policy.PSObject.TypeNames.Insert(0,'Monkey365.Azure.ACS_Policy')
			$acs_entries += $Unit_Policy
		}
	}
	end {
		if ($acs_entries) {
			$acs_entries.PSObject.TypeNames.Insert(0,'Monkey365.Azure.securitycenter.acsbuiltin.parameters')
			[pscustomobject]$obj = @{
				Data = $acs_entries;
				Metadata = $monkey_metadata;
			}
			$returnData.az_asc_builtin_policies = $obj
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Microsoft Defender for Cloud BuiltIn",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Tags = @('AzureKeySecCenterEmptyResponse');
				Verbose = $O365Object.Verbose;
			}
			Write-Verbose @msg
		}
	}
}








