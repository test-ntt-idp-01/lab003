package test

import (
 "testing"
 "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {

terraformOptions :=&terraform.Options{
TerraformDir: ".", }

terraform.Plan(t, terraformOptions)
terraform.Apply(t, terraformOptions)
defer terraform.Destroy(t, terraformOptions)

}

