ENV ?= minikube
TF ?= terraform
TF_DIR := terraform/environments/$(ENV)

.PHONY: help
help:
	@printf "Usage: make <target> ENV=<environment>\n\n"
	@printf "Targets:\n"
	@printf "  tf-fmt        Format all Terraform files\n"
	@printf "  tf-init       Initialize the selected environment\n"
	@printf "  tf-plan       Plan the selected environment without the root Application\n"
	@printf "  tf-apply      Apply the selected environment without the root Application\n"
	@printf "  tf-plan-root  Plan with the Argo CD root Application enabled\n"
	@printf "  tf-apply-root Apply with the Argo CD root Application enabled\n"

.PHONY: tf-fmt
tf-fmt:
	$(TF) fmt -recursive

.PHONY: tf-init
tf-init:
	$(TF) -chdir=$(TF_DIR) init

.PHONY: tf-plan
tf-plan:
	$(TF) -chdir=$(TF_DIR) plan

.PHONY: tf-apply
tf-apply:
	$(TF) -chdir=$(TF_DIR) apply

.PHONY: tf-plan-root
tf-plan-root:
	$(TF) -chdir=$(TF_DIR) plan -var="enable_root_application=true"

.PHONY: tf-apply-root
tf-apply-root:
	$(TF) -chdir=$(TF_DIR) apply -var="enable_root_application=true"
