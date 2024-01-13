#Requires -Version 5
<#
	.SYNOPSIS
	
	Initializes the Carpenter-AzurePipelines pipeline.

	.DESCRIPTION

	Performs initialization of the Carpenter-AzurePipelines pipeline, validates and generates
	parameters and variables, and configures and initialize pipeline operations.

	.NOTES

	This script is expected to be executed by Carpenter-AzurePipelines.

	.INPUTS

	None. You cannot pipe objects to InitializePipeline.ps1.

	.OUTPUTS

	None.
	
	.EXAMPLE

	PS> InitializePipeline.ps1

#>

[CmdletBinding()]
param(

)

# script variables
$path = Get-Location
Write-Debug "path: $path"
$scriptName = $MyInvocation.MyCommand.Name
Write-Debug "scriptName: $scriptName"
$scriptPath = $MyInvocation.MyCommand.Source
Write-Debug "scriptPath: $scriptPath"
$scriptRoot = $PSScriptRoot
Write-Debug "scriptRoot: $scriptRoot"

$scriptName = Split-Path $PSCommandPath -Leaf
. "$scriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"
