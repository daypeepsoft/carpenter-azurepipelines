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
	
	.PARAMETER PipelineVersion

    The version of the pipeline template. Defaults to CARPENTER_PIPELINE_VERSION environment variable.

	.EXAMPLE

	PS> InitializePipeline.ps1

#>

[CmdletBinding()]
param(
	[string] $PipelineVersion		= $env:CARPENTER_PIPELINE_VERSION,
	[string] $PipelineOperations	= $env:CARPENTER_PIPELINE_OPERATIONS,
	[string] $PipelinePath			= $env:CARPENTER_PIPELINE_PATH,
	[string] $PipelineScriptPath	= $env:CARPENTER_PIPELINE_SCRIPTPATH,
	[string] $PipelineScriptDebug	= $env:CARPENTER_PIPELINE_SCRIPTDEBUG,
	[string] $PipelineScriptVerbose = $env:CARPENTER_PIPELINE_SCRIPTVERBOSE
)
# script variables
$currentPipelineVersion = 2
Write-Debug "currentPipelineVersion: $currentPipelineVersion"
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


Write-Verbose "Validating Carpenter-AzurePipelines configuration"

######################################################################################################################
# Pipeline Settings
######################################################################################################################

Write-Debug "Validating Pipeline Settings"

# Carpenter.Pipeline.Version (pipelineVersion)
Write-Debug "Validating Carpenter.Pipeline.Version (pipelineVersion)"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to the Carpenter-AzurePipelines template."
}
if ($PipelineVersion -gt $currentPipelineVersion) {
	Write-PipelineWarning "The pipelineVersion parameter ($PipelineVersion) is greater than the current Carpenter-AzurePipelines template pipeline version. Future changes could break your build."
}
if ($PipelineVersion -lt $currentPipelineVersion) {
	Write-PipelineWarning "The pipelineVersion parameter ($PipelineVersion) is less than the current Carpenter-AzurePipelines template pipeline version. You may be missing out on awesome features."
}
$pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Version" -OutputVariableName "pipelineVersion" -Value $PipelineVersion

# Carpenter.Pipeline.Operations (operations)
Write-Debug "Validating Carpenter.Pipeline.Operations (pipelineOperations)"
$ops = ConvertFrom-Json $PipelineOperations
if ($ops.Count -eq 0) {
	Write-PipelineWarning "No pipelineOperations have been defined in the pipeline that extend Carpenter.AzurePipelines. For more information: https://github.com/daypeepsoft/carpenter-azurepipelines/blob/main/docs/configuration.md#carpenterpipelineoperations-pipelineoperations"
}
$validOps = "ExcludePipeline"
foreach ($op in $ops) {
	if (-not ($validOps -contains $op)) {
		Write-PipelineError "Unrecognized pipelineOperation parameter '$op'."
	}
}
$pipelineOperations = Set-CarpenterVariable -VariableName Carpenter.Pipeline.Operations -OutputVariableName "pipelineOperations" -Value $($PipelineOperations -replace "  ","" -replace "`n"," " -replace "`r","")

# Carpenter.Pipeline.Path
Write-Debug "Validating Carpenter.Pipeline.Path"
if (-not (Test-Path -Path $pipelinePath -PathType Container)) {
	Write-PipelineWarning "Carpenter.Pipeline.Path does not exist: $pipelinePath"
}
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value (FixPath $PipelinePath)

# Carpenter.Pipeline.ScriptPath
Write-Debug "Validating Carpenter.Pipeline.ScriptPath"
if (-not (Test-Path -Path $pipelineScriptPath -PathType Container)) {
	Write-PipelineWarning "Carpenter.Pipeline.ScriptPath does not exist: $pipelineScriptPath"
}
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value (FixPath $PipelineScriptPath)

Write-Debug "Validating Carpenter.Pipeline.ScriptDebug (scriptDebug)"
if ((-not ('True' -eq $PipelineScriptDebug)) -and (-not ('False' -eq $PipelineScriptDebug))) {
	Write-PipelineError "scriptDebug parameter must be True or False."
}
$pipelineScriptDebug = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptDebug" -OutputVariableName "pipelineScriptDebug" -Value $PipelineScriptDebug

Write-Debug "Validating Carpenter.Pipeline.ScriptVerbose (scriptVerbose)"
if ((-not ('True' -eq $PipelineScriptVerbose)) -and (-not ('False' -eq $PipelineScriptVerbose))) {
	Write-PipelineError "scriptVerbose parameter must be True or False."
}
$pipelineScriptVerbose = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptVerbose" -OutputVariableName "pipelineScriptVerbose" -Value $PipelineScriptVerbose
