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


function Get-MonkeyRestEXOUser {
<#
        .SYNOPSIS
		Collector to get information about users in Exchange Online

        .DESCRIPTION
		Collector to get information about users in Exchange Online

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyRestEXOUser
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
		#Getting environment
		#Collector metadata
		$monkey_metadata = @{
			Id = "exo0029";
			Provider = "Microsoft365";
			Resource = "ExchangeOnline";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyRestEXOUser";
			ApiType = "ExoApi";
			description = "Collector to get information about users in Exchange Online";
			Group = @(
				"ExchangeOnline"
			);
			Tags = @(

			);
			references = @(
				"https://silverhack.github.io/monkey365/"
			);
			ruleSuffixes = @(
				"o365_exo_users"
			);
			dependsOn = @(

			);
			enabled = $true;
			supportClientCredential = $true
		}
		$Environment = $O365Object.Environment
		#Get EXO authentication
		$exo_auth = $O365Object.auth_tokens.ExchangeOnline
	}
	process {
		$msg = @{
			MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Exchange Online users",$O365Object.TenantID);
			callStack = (Get-PSCallStack | Select-Object -First 1);
			logLevel = 'info';
			InformationAction = $InformationAction;
			Tags = @('ExoUsersInfo');
		}
		Write-Information @msg
		#Get data
		$p = @{
			Authentication = $exo_auth;
			Environment = $Environment;
			ResponseFormat = 'clixml';
			Command = 'Get-User -ResultSize unlimited';
			Method = "POST";
			InformationAction = $O365Object.InformationAction;
			Verbose = $O365Object.Verbose;
			Debug = $O365Object.Debug;
		}
		$exo_users = Get-PSExoAdminApiObject @p
	}
	end {
		if ($exo_users) {
			$exo_users.PSObject.TypeNames.Insert(0,'Monkey365.ExchangeOnline.Users')
			[pscustomobject]$obj = @{
				Data = $exo_users;
				Metadata = $monkey_metadata;
			}
			$returnData.o365_exo_users = $obj
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Exchange Online users",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Tags = @('ExoUsersEmptyResponse');
				Verbose = $O365Object.Verbose;
			}
			Write-Verbose @msg
		}
	}
}








