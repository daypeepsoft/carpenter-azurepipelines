# Configuring Carpenter-AzurePipelines

Carpenter-AzurePipelines can be easily configured using the documentation below.

* [Settings Heirarchy](#settings-heirarchy)
  * [YAML Parameter](#yaml-parameter)
  * [YAML Variable](#yaml-variable)
  * [YAML Variable Group](#yaml-variable-group)
  * [Pipeline Definition Variable](#pipeline-definition-variable)
  * [Pipeline Definition Variable Group](#pipeline-definition-variable-group)
* [Pipeline Settings](#pipeline-settings)
  * [Carpenter.Pipeline.Version (pipelineVersion)](#carpenterpipelineversion-pipelineversion)
  * [Carpenter.Pipeline.Operations (pipelineOperations)](#carpenterpipelineoperations-pipelineoperations)
  * [Carpenter.Pipeline.Directory](#carpenterpipelinedirectory)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)

## Settings hierarchy

To take advantage of a larger feature set in Microsoft Azure DevOps pipelines, Carpenter-AzurePipelines settings are
implemented at multiple layers in the pipeline. This document serves to describe Carpenter variables and document the
layer to which a setting is applied.

### YAML Parameter

YAML parameters are used when the value of the settings could change the pipeline during template expansion.
Parameters are used in this case because variables are not yet populated.  In contrast to using the condition
parameter, which can be done with a variable, elements can be excluded from the pipeline completely when the
template is expanded.

YAML parameters are also used to pass service connection strings, as service connection permissions are validated
during pipeline expansion.

YAML parameters should only be used where necessary as extra overhead is incurred when using parameters, for example
plumbing through a new parameter is much more work than using a variable.

### YAML Variable

Variables that are set at the Pipeline YAML level are the preferred location for Carpenter-AzurePipelines
configuration.  If there is no reason to use any other method of configuration, YAML variables should be used.

### YAML Variable Group

Variable groups linked through the pipeline YAML should be used when configuration settings are used across multiple
pipelines.

### Pipeline Definition Variable

Variables defined in the pipeline definition are useful when configuration settings might need to be changed when
the build is executed.

### Pipeline Definition Variable Group

Currently there is no reason to use variable groups linked through the pipeline definition.

## Pipeline Settings

### Carpenter.Pipeline.Version (pipelineVersion)

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines. A breaking change
could implement new functionality under an incremented version number, and move dependent pipelines over separately.
This value is set by the `pipelineVersion` parameter. The default value is **2**. 

To ensure that future changes to the pipeline do not break pipelines which extend this template, it is recommended
that this parameter is passed to the template.

For more information, see: [pipeline-versioning.md](features/pipeline-versioning.md)

### Carpenter.Pipeline.Operations (pipelineOperations)

Defines the operations for a pipeline. This value is set by the `pipelineOperations` parameter.

For more information, see: [operations.md](operations.md)

### Carpenter.Pipeline.Directory

The name of the directory that contains the Carpenter pipeline supporting files. The value is **.carpenter-azurepipelines**.

### Carpenter.Pipeline.Path

The absolute path to the Carpenter pipeline supporting files. This value is determined during template expansion.

### Carpenter.Pipeline.ScriptPath

The absolute path to the Carpenter pipeline scripts. This value is determined during template expansion.
