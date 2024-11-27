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

Function New-OcsfDetectionFindingObject{
    <#
        .SYNOPSIS
        Get OCSF detection finding object
        .DESCRIPTION
        Get OCSF detection finding object
        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: New-OcsfDetectionFindingObject
            Version     : 1.0

        .LINK
            https://github.com/silverhack/monkey365
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Scope="Function")]
    [OutputType([System.Management.Automation.PSCustomObject])]
	param()
    Process{
        $properties = @(
            'metadata','SeverityId','severity',
            'status','statusCode','statusDetail',
            'statusId','unmapped','activityName','activityId',
            'FindingInfo','resources','categoryName','categoryId',
            'className','classId','cloud','time','remediation',
            'typeId','typeName'
        )
        [Ocsf.Finding.Detection]::new() | Select-Object $properties
    }
}