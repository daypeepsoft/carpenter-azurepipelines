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
	[string] $PipelineOperations	= $env:CARPENTER_PIPELINE_OPERATIONS
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
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value $PipelinePath
if (-not (Test-Path -Path $pipelinePath -PathType Directory)) {
	Write-PipelineWarning "Carpenter.Pipeline.Path does not exist: $pipelinePath"
}

# Carpenter.Pipeline.ScriptPath
Write-Debug "Validating Carpenter.Pipeline.ScriptPath"
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value $PipelineScriptPath
if (-not (Test-Path -Path $pipelineScriptPath -PathType Directory)) {
	Write-PipelineWarning "Carpenter.Pipeline.ScriptPath does not exist: $pipelineScriptPath"
}
