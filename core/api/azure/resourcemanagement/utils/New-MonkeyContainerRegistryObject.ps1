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

Function New-MonkeyContainerRegistryObject {
<#
        .SYNOPSIS
		Create a new container registry object

        .DESCRIPTION
		Create a new container registry object

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: New-MonkeyContainerRegistryObject
            Version     : 1.0

        .LINK
            https://github.com/silverhack/monkey365
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Scope="Function")]
	[CmdletBinding()]
	Param (
        [parameter(Mandatory= $True, ValueFromPipeline = $True, HelpMessage="Container registry object")]
        [Object]$InputObject
    )
    Process{
        try{
            #Create ordered dictionary
            $ContainerRegistryObject = [ordered]@{
                id = $InputObject.Id;
		        name = $InputObject.Name;
                location = $InputObject.location;
		        tags = $InputObject.tags;
                sku = $InputObject.sku;
                type = $InputObject.type;
                properties = $InputObject.properties;
                resourceGroupName = $InputObject.Id.Split("/")[4];
                allowAccessFromAllNetworks = $null;
                scopeMap = $null;
                tokens = $null;
                replication = $null;
                locks = $null;
                diagnosticSettings = [PSCustomObject]@{
                    enabled = $false;
                    name = $null;
                    id = $null;
                    properties = $null;
                    rawData = $null;
                };
                rawObject = $InputObject;
            }
            #Create PsObject
            $_obj = New-Object -TypeName PsObject -Property $ContainerRegistryObject
            #return object
            return $_obj
        }
        catch{
            $msg = @{
			    MessageData = ($message.MonkeyObjectCreationFailed -f "Container registry object");
			    callStack = (Get-PSCallStack | Select-Object -First 1);
			    logLevel = 'error';
			    InformationAction = $O365Object.InformationAction;
			    Tags = @('ContainerRegistryObjectError');
		    }
		    Write-Error @msg
            $msg.MessageData = $_
            $msg.LogLevel = "Verbose"
            $msg.Tags+= "ContainerRegistryObjectError"
            [void]$msg.Add('verbose',$O365Object.verbose)
		    Write-Verbose @msg
        }
    }
}