<#
	.SYNOPSIS

	Common functions used by Carpenter-AzurePipelines.

#>

function FixPath {
<#
.SYNOPSIS
    Fixes a path to make it consistent.

.PARAMETER Path
    The path to fix.
#>
param(
    [string] $Path
)
return $Path.Replace("\",[IO.Path]::DirectorySeparatorChar).Replace("/",[IO.Path]::DirectorySeparatorChar)
} #end of function FixPath

function IsNumeric {
 
<#   
.SYNOPSIS   
    Analyse whether input value is numeric or not
   
.DESCRIPTION   
    Allows the administrator or programmer to analyse if the value is numeric value or 
    not.
     
    By default, the return result value will be in 1 or 0. The binary of 1 means on and 
    0 means off is used as a straightforward implementation in electronic circuitry 
    using logic gates. Therefore, I have kept it this way. But this IsNumeric cmdlet 
    will return True or False boolean when user specified to return in boolean value 
    using the -Boolean parameter.
 
.PARAMETER Value
     
    Specify a value
 
.PARAMETER Boolean
     
    Specify to return result value using True or False
 
.EXAMPLE
    Get-ChildItem C:\Windows\Logs | where { $_.GetType().Name -eq "FileInfo" } | Select -ExpandProperty Name | IsNumeric -Verbose
    DirectX.log
    VERBOSE: False
    0
    IE9_NR_Setup.log
    VERBOSE: False
    0
 
    The default return value is 0 when we attempt to get the files name through the 
    pipeline. You can see the Verbose output stating False when you specified the 
    -Verbose parameter
 
.EXAMPLE
    Get-ChildItem C:\Windows\Logs | where { $_.GetType().Name -eq "FileInfo" } | Select -ExpandProperty Length | IsNumeric -Verbose
    119155
    VERBOSE: True
    1
    2740
    VERBOSE: True
    1
     
    The default return value is 1 when we attempt to get the files length through the 
    pipeline. You can see the Verbose output stating False when you specified the 
    -Verbose parameter
         
.EXAMPLE
    $IsThisNumbers? = ("1234567890" | IsNumeric -Boolean) ; $IsThisNumbers?
    True
     
    The return value is True for the input value 1234567890 because we specified the 
    -Boolean parameter
     
.EXAMPLE    
    $IsThisNumbers? = ("ABCDEFGHIJ" | IsNumeric -Boolean) ; $IsThisNumbers?
    False
 
    The return value is False for the input value ABCDEFGHIJ because we specified the 
    -Boolean parameter
 
.NOTES   
    Author  : Ryen Kia Zhi Tang
    Date    : 20/07/2012
    Blog    : ryentang.wordpress.com
    Version : 1.0
     
#>
 
[CmdletBinding(
    SupportsShouldProcess=$True,
    ConfirmImpact='High')]
 
param (
 
[Parameter(
    Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
     
    $Value,
     
[Parameter(
    Mandatory=$False,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [alias('B')]
    [Switch] $Boolean
     
)
     
BEGIN {
 
    #clear variable
    $IsNumeric = 0
 
}
 
PROCESS {
 
    #verify input value is numeric data type
    try { 0 + $Value | Out-Null
    $IsNumeric = 1 }catch{ $IsNumeric = 0 }
 
    if($IsNumeric){ 
        $IsNumeric = 1
        if($Boolean) { $Isnumeric = $True }
    }else{ 
        $IsNumeric = 0
        if($Boolean) { $IsNumeric = $False }
    }
     
    if($PSBoundParameters['Verbose'] -and $IsNumeric) { 
    Write-Verbose "True" }else{ Write-Verbose "False" }
     
    
    return $IsNumeric
}
 
END {}
 
} #end of function IsNumeric


Function Set-CarpenterVariable {

    <#
        .SYNOPSIS

        Sets a variable which is available to other tasks in the current job, or in future jobs or stages.

        .PARAMETER VariableName

        The name of the variable, available to other steps in this job.

        .PARAMETER OutputVariableName

        The optional name of the variable, available to future jobs and stages in this pipeline.

        .PARAMETER Value

        The variables value.

        .EXAMPLE

        $pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Version" -OutputVariableName "pipelineVersion" -Value $PipelineVersion
    #>

	param(
		[string] $VariableName,
		[object] $Value,
		[string] $OutputVariableName
	)
	If ($VariableName) {
		Write-Debug "$($VariableName): $Value"
		Write-Host "##vso[task.setvariable variable=$VariableName]$Value" 
	} elseif ($OutputVariableName) {
		Write-Debug "$($OutputVariableName): $Value"
	}
	if ($OutputVariableName) { Write-Host "##vso[task.setvariable variable=$OutputVariableName;isOutput=true]$Value" }
	return $Value
} #end of function Set-CarpenterVariable


Function Write-PipelineError {
    <#
        .SYNOPSIS

        Writes a standard pipeline error message.

        .PARAMETER Message

        The message text describing the error.

    #>
	param(
		[string] $Message
	)
    Write-Host "##vso[task.logissue type=error]$Message"
	Throw $Message
} #end of function Write-PipelineError


Function Write-PipelineWarning {
    <#
        .SYNOPSIS

        Writes a standard pipeline warning message.

        .PARAMETER Message

        The message text describing the warning.

    #>
	param(
		[string] $Message
	)
    Write-Host "##vso[task.logissue type=warning]$Message"
	Write-Warning $Message
} #end of function Write-PipelineWarning


Function Write-ScriptHeader {

	<#
		.SYNOPSIS

		Writes the header for the executing script.

        .PARAMETER Name

        The name of the script.
	#>

	param(
		[string] $Name
	)
	Write-Verbose "$Name"
} #end of function Write-ScriptHeader
