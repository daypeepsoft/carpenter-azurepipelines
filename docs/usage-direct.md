# Using Carpenter-AzurePipelines directly

## Prerequisites

* Azure DevOps project
* GitHub account

## Extend the Carpenter pipeline templates

1. Create GitHub service connection
    
    Azure DevOps needs a service connection to communicate with GitHub. You can skip this step if your project already has a service connection to GitHub.

    Note: Be sure to use a `Service connection` and do not use `GitHub connections`.

2. Link to Carpenter from your Azure Pipeline YAML

    ``` yaml
    resources:
      repositories:
      - repository: Carpenter
        type: github
        name: daypeepsoft/carpenter-azurepipelines
        # The repository endpoint value should match the name of your service connection.
        endpoint: https://github.com
        ref: refs/heads/branch/branch-name # Select the branch to use

    stages:
    - template: template/default.yml@Carpenter
      parameters:
        pipelineVersion: 2
        # YOUR PROJECT CONFIGURATION GOES HERE
        # see Carpenter documentation
    ```

You should now be able to execute your pipeline extending templates provided by Carpenter.
