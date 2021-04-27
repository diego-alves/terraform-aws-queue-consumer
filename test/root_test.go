package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestRootExample(t *testing.T) {
	t.Parallel()
	expectedRegion := "us-east-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": expectedRegion,
		},

		Vars: map[string]interface{}{
			// TODO add all required variables here
		},

		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "output")
	outputMap := terraform.OutputMap(t, terraformOptions, "output_map")

	assert.Equal(t, expectedRegion, output)
	assert.Regexp(t, "^\\d{12}$", outputMap)

}
