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


function Get-MonkeyAADRMConfig {
<#
        .SYNOPSIS
		Collector to get information about AADRM config

        .DESCRIPTION
		Collector to get information about AADRM config

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyAADRMConfig
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
		#Get Access Token from AADRM
		#Collector metadata
		$monkey_metadata = @{
			Id = "aadrm01";
			Provider = "Microsoft365";
			Resource = "IRM";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyAADRMConfig";
			ApiType = $null;
			description = "Collector to get information about AADRM config";
			Group = @(
				"Purview";
				"ExchangeOnline"
			);
			Tags = @(

			);
			references = @(
				"https://silverhack.github.io/monkey365/"
			);
			ruleSuffixes = @(
				"o365_aadrm_config"
			);
			dependsOn = @(

			);
			enabled = $true;
			supportClientCredential = $true
		}
		$access_token = $O365Object.auth_tokens.AADRM
		#Get AADRM Url
		$url = $O365Object.Environment.aadrm_service_locator
		if ($null -ne $access_token) {
			#Set Authorization Header
			$AuthHeader = ("MSOID {0}" -f $access_token.AccessToken)
			$requestHeader = @{ "Authorization" = $AuthHeader }
		}
	}
	process {
		if ($requestHeader -and $url) {
			$msg = @{
				MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Office 365 Rights Management: Configuration",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = 'info';
				InformationAction = $InformationAction;
				Tags = @('AADRMConfig');
			}
			Write-Information @msg
			$url = ("{0}/Configuration" -f $url)
			$params = @{
				url = $url;
				Method = 'Get';
				ContentType = 'application/json; charset=utf-8';
				Headers = $requestHeader;
				disableSSLVerification = $true;
				InformationAction = $O365Object.InformationAction;
				Verbose = $O365Object.Verbose;
				Debug = $O365Object.Debug;
			}
			#call AADRM endpoint
			$aadrm_config = Invoke-MonkeyWebRequest @params
		}
	}
	end {
		if ($aadrm_config) {
			$aadrm_config.PSObject.TypeNames.Insert(0,'Monkey365.AADRM.Config')
			[pscustomobject]$obj = @{
				Data = $aadrm_config;
				Metadata = $monkey_metadata;
			}
			$returnData.o365_aadrm_config = $obj
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Office 365 Rights Management Configuration",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Tags = @('AADRMConfigEmptyResponse');
				Verbose = $O365Object.Verbose;
			}
			Write-Verbose @msg
		}
	}
}








