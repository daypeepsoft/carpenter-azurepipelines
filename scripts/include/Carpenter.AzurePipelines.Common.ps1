<#
	.SYNOPSIS

	Common functions used by Carpenter-AzurePipelines.

#>
Function Write-ScriptHeader {

	<#
		.SYNOPSIS

		Writes the header for the executing script.

	#>

	param(
		[string] $Name
	)
	Write-Verbose "$Name"
}
