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


function Get-MonkeyAzSecurityStatusInfo {
<#
        .SYNOPSIS
		Collector to get information about Security Statuses from Azure

        .DESCRIPTION
		Collector to get information about Security Statuses from Azure

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyAzSecurityStatusInfo
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
			Id = "az00099";
			Provider = "Azure";
			Resource = "Subscription";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyAzSecurityStatusInfo";
			ApiType = "resourceManagement";
			description = "Collector to get information about Security Statuses from Azure";
			Group = @(
				"Subscription";
				"DefenderForCloud"
			);
			Tags = @(

			);
			references = @(
				"https://silverhack.github.io/monkey365/"
			);
			ruleSuffixes = @(
				"az_security_status"
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
		#Get config
		$AzureSecStatus = $O365Object.internal_config.ResourceManager | Where-Object { $_.Name -eq "azureSecurityStatuses" } | Select-Object -ExpandProperty resource
		#Get resource groups
		$resource_groups = $O365Object.resourcegroups
		#set array
		$security_statuses = @()
	}
	process {
		$msg = @{
			MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Azure Security Status",$O365Object.current_subscription.displayName);
			callStack = (Get-PSCallStack | Select-Object -First 1);
			logLevel = 'info';
			InformationAction = $InformationAction;
			Tags = @('AzureSecStatusInfo');
		}
		Write-Information @msg
		#Get all Security Status
		$params = @{
			Authentication = $rm_auth;
			Provider = $AzureSecStatus.Provider;
			ObjectType = "securityStatuses";
			Environment = $Environment;
			ContentType = 'application/json';
			Method = "GET";
			APIVersion = $AzureSecStatus.api_version;
		}
		$AllStatus = Get-MonkeyRMObject @params
		#iterate over all resource_groups
		foreach ($resource_group in $resource_groups) {
			$matched = $AllStatus | Where-Object { $_.Id -like ("{0}*" -f $resource_group.Id) }
			if ($matched) {
				#Add to array
				$security_statuses += $matched
			}
		}

	}
	end {
		if ($security_statuses) {
			$security_statuses.PSObject.TypeNames.Insert(0,'Monkey365.Azure.SecurityStatus')
			[pscustomobject]$obj = @{
				Data = $security_statuses;
				Metadata = $monkey_metadata;
			}
			$returnData.az_security_status = $obj
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Azure Security Status",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Tags = @('AzureKeySecStatusEmptyResponse');
				Verbose = $O365Object.Verbose;
			}
			Write-Verbose @msg
		}
	}
}








