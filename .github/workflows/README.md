# AWS Terraform GitHub Actions Workflows

This repository contains GitHub Actions workflows designed for the provisioning and destruction of AWS resources using Terraform, managed by `w4ss1m`. These workflows streamline the infrastructure management process, catering to both development and production environments.

## Workflows Overview

### 1. (Optional) Provision BackEnd Terraform

**File:** `backend-provision.yml`

This workflow is designed to optionally provision the Terraform backend resources, specifically an S3 bucket and DynamoDB table. It's manually triggered via the GitHub UI and focuses on setting up the necessary backend infrastructure for state management in Terraform.

#### Improvements:
- Provides flexibility in managing backend resources separately from other AWS resources.
- Automates the setup of a secure and robust Terraform backend.

### 2. Provision/Destroy Aws Ressources in one click 

**File:** `aws-provision-destroy.yml`

This workflow facilitates the provisioning or destruction of AWS resources without directly interacting with the Terraform backend. It's ideal for managing resources like EC2 instances, S3 buckets, or any AWS services required by your application, triggered manually with an option to provision or destroy.

#### Improvements:
- Enables direct management of AWS resources, offering a streamlined process for environments with pre-configured backend settings.
- Enhances the flexibility of resource management by bypassing backend configurations during execution.

#### Improvements:
- Consolidates the management of Terraform backend and AWS resources into a single workflow for simplicity and coherence.
- Ensures a sequential execution order, establishing the backend before provisioning other resources and vice versa for destruction.

## General Workflow Structure

Each workflow is crafted to provide:
- **Manual Triggering**: Flexibility through GitHub UI, allowing specific actions (provision or destroy) based on immediate needs.
- **Secure Configuration**: Utilization of GitHub Secrets for sensitive information (AWS credentials) and environment variables for easy adjustments.
- **Version Compatibility**: Ensured through specified Terraform versions, maintaining stability across operations.

## How to Use These Workflows

### For Non-Technical Users

Imagine these workflows as a remote control for your AWS infrastructure, allowing you to set up or dismantle services with the click of a button, akin to building or breaking down a Lego set.

### For Technical Users

1. Navigate to the **Actions tab** in the GitHub repository.
2. Select the desired **workflow**.
3. Click on **'Run workflow'**, choose the branch and action type (`provision` or `destroy`).
4. Confirm by clicking **'Run workflow'** again to initiate the process.

## Maintainer

Managed by `w4ss1m`. For any contributions, suggestions, or issues, please feel free to contact the maintainer directly or utilize the repository's issues and pull request features.

## Contribution

Contributions are highly encouraged! If you wish to improve these workflows or have new feature suggestions, please fork the repository, submit a pull request, or open an issue for discussion.
