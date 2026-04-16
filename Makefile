ENV ?= minikube
TF ?= terraform
TF_DIR := terraform/environments/$(ENV)
TF_PLAN ?= tfplan.tfplan
TF_PLAN_ROOT ?= tfplan-root.tfplan

.PHONY: help
help:
	@printf "Usage: make <target> ENV=<environment>\n\n"
	@printf "Targets:\n"
	@printf "  tf-fmt        Format all Terraform files\n"
	@printf "  tf-init       Initialize the selected environment\n"
	@printf "  tf-plan       Save a plan file without the root Application\n"
	@printf "  tf-apply      Apply the saved plan file without the root Application\n"
	@printf "  tf-plan-root  Save a plan file with the root Application enabled (bootstrap envs only)\n"
	@printf "  tf-apply-root Apply the saved plan file with the root Application enabled (bootstrap envs only)\n"

.PHONY: tf-fmt
tf-fmt:
	$(TF) fmt -recursive

.PHONY: tf-init
tf-init:
	$(TF) -chdir=$(TF_DIR) init

.PHONY: tf-plan
tf-plan:
	$(TF) -chdir=$(TF_DIR) plan -out=$(TF_PLAN)

.PHONY: tf-apply
tf-apply:
	$(TF) -chdir=$(TF_DIR) apply $(TF_PLAN)

.PHONY: tf-plan-root
tf-plan-root:
	$(TF) -chdir=$(TF_DIR) plan -out=$(TF_PLAN_ROOT) -var="enable_root_application=true"

.PHONY: tf-apply-root
tf-apply-root:
	$(TF) -chdir=$(TF_DIR) apply $(TF_PLAN_ROOT)
