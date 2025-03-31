# 🚀 BigQuery Support Role Assignment Script

This script grants a predefined set of BigQuery permissions to the internal support group `bq-support@sela.co.il` on a specified Google Cloud project.

## 📄 What It Does

- Prompts the user for a GCP Project ID
- Creates or updates a custom IAM role with specific BigQuery permissions:
  - `bigquery.tables.get`
  - `bigquery.tables.list`
  - `bigquery.routines.get`
  - `bigquery.routines.list`
  - `bigquery.jobs.listAll`
  - `bigquery.tables.getData`
- Assigns the custom role to the support group

## 🧑‍💻 Usage

1. Open [Google Cloud Shell](https://shell.cloud.google.com/)
2. Clone this repo:
   ```bash
   git clone https://github.com/saritbm/bq-support-permissions-script
   cd bq-support-permissions-script
   ```
3. Run the script:
   ```bash
   bash grant_bq_support.sh
   ```

## ✅ Requirements

To run this script successfully, you must have:
- Permission to create or update IAM custom roles
- Permission to assign IAM policy bindings
- Roles like `Owner`, `Project IAM Admin`, or `IAM Role Admin`

