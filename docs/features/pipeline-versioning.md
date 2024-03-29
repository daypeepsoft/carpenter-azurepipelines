# Pipeline Versioning

Pipeline versioning in Carpenter-AzurePipelines allows breaking changes to be made to the common template yaml without
breaking builds which extend the Carpenter templates. This is accomplished through the 
[`pipelineVersion`](../configuration.md#carpenterpipelineversion-pipelineversion) parameter and conditions defined in
the template yaml files.

## Usage

You can define the pipline version that you want to use in your pipeline yaml:
```
stages:
- template: template/default.yml@Carpenter
  parameters:
    pipelineVersion: 2
```

When making a breaking change [`pipelineVersion`](../configuration.md#carpenterpipelineversion-pipelineversion)
can be used to require manual intervention to pipelines which extend this template.

This step can be modified:
```
- script: |
    # do something

```

to this:
```
- ${{ if eq(parameters.pipelineVersion,2) }}:
  - script: | 
      # do something
- ${{ if gt(parameters.pipelineVersion,2) }}:
  - script: | 
      # do something differently in a breaking way
```

while not breaking existing pipelines that extend the template.

## Deprecation

The [`pipelineVersion`](../configuration.md#carpenterpipelineversion-pipelineversion)
parameter can also be used for template feature deprecation.

For example, warn that a feature should no longer be used:
```
- ${{ if and(containsValue(parameters.pipelineOperations,'someFeature'),lt(parameters.pipelineVersion,3)) }}:
  - script: | 
      echo ##vso[task.logissue type=warning]someFeature has been deprecated and should not be used, please replace with newFeature.
```

Or fully disable a feature:
```
- ${{ if and(containsValue(parameters.pipelineOperations,'someFeature'),lt(parameters.pipelineVersion,3)) }}:
  - script: | 
      echo ##vso[task.logissue type=error]someFeature is obsolete and can not be used, please replace with newFeature.
```
