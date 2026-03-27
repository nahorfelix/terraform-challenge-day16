package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebserverCluster(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Fixture supplies the AWS provider; the module under test has no provider blocks.
		TerraformDir: "./fixtures/webserver-cluster",
		Vars: map[string]interface{}{
			"cluster_name":               "test-cluster",
			"project_name":               "terratest",
			"team_name":                  "platform",
			"instance_type":              "t2.micro",
			"min_size":                   1,
			"max_size":                   2,
			"environment":                "dev",
			"enable_detailed_monitoring": false,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	albDnsName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := "http://" + albDnsName

	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello World", 30, 10*time.Second)
}
