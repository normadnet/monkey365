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


function Get-MonkeyAzVMScaleSet {
<#
        .SYNOPSIS
		Collector to get information about Virtual Machine Scale set

        .DESCRIPTION
		Collector to get information about Virtual Machine Scale set

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyAzVMScaleSet
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
			Id = "az00053";
			Provider = "Azure";
			Resource = "VirtualMachines";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyAzVMScaleSet";
			ApiType = "resourceManagement";
			description = "Collector to get information about Redis instances from Azure";
			Group = @(
				"VirtualMachines"
			);
			Tags = @(

			);
			references = @(
				"https://silverhack.github.io/monkey365/"
			);
			ruleSuffixes = @(
				"az_vm_scaleset"
			);
			dependsOn = @(

			);
			enabled = $true;
			supportClientCredential = $true
		}
		#Get Config
		$AzureVMScaleConfig = $O365Object.internal_config.ResourceManager | Where-Object { $_.Name -eq "azureVMScaleSet" } | Select-Object -ExpandProperty resource
		#Get vm instances
		$vms = $O365Object.all_resources.Where({ $_.Id -like "*Microsoft.Compute/virtualMachineScaleSets*" })
		if (-not $vms) { continue }
		$AllVMs = $null
	}
	process {
		$msg = @{
			MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Azure Virtual Machine scale set",$O365Object.current_subscription.displayName);
			callStack = (Get-PSCallStack | Select-Object -First 1);
			logLevel = 'info';
			InformationAction = $O365Object.InformationAction;
			Tags = @('AzureVMInfo');
		}
		Write-Information @msg
		if ($vms) {
			$new_arg = @{
				APIVersion = $AzureVMScaleConfig.api_version;
			}
			$p = @{
				ScriptBlock = { Get-MonkeyAzVMScaleSetInfo -InputObject $_ };
				Arguments = $new_arg;
				Runspacepool = $O365Object.monkey_runspacePool;
				ReuseRunspacePool = $true;
				Debug = $O365Object.VerboseOptions.Debug;
				Verbose = $O365Object.VerboseOptions.Verbose;
				MaxQueue = $O365Object.nestedRunspaces.MaxQueue;
				BatchSleep = $O365Object.nestedRunspaces.BatchSleep;
				BatchSize = $O365Object.nestedRunspaces.BatchSize;
			}
			$AllVMs = $vms | Invoke-MonkeyJob @p
		}
	}
	end {
		if ($AllVMs) {
			$AllVMs.PSObject.TypeNames.Insert(0,'Monkey365.Azure.VMScaleSet')
			[pscustomobject]$obj = @{
				Data = $AllVMs;
				Metadata = $monkey_metadata;
			}
			$returnData.az_vm_scaleSet = $obj;
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Azure Virtual Machine scale set",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Tags = @('AzureVMEmptyResponse');
				Verbose = $O365Object.Verbose;
			}
			Write-Verbose @msg
		}
	}
}








