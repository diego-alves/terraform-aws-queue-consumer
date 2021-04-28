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
			"name": "QueueConsumerTest",
			// TODO add all required variables here
		},

		NoColor: false,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, "default")
	terraform.InitAndApply(t, terraformOptions)

	queue := terraform.OutputMap(t, terraformOptions, "queue")

	assert.Equal(t, "https://sqs.us-west-2.amazonaws.com/760373735544/QueueConsumerTest.fifo", queue["url"])

}
