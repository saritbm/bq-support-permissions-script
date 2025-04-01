#!/bin/bash

echo "🔐 Granting custom BigQuery permissions to bq-support@sela.co.il"

# Prompt for project ID
read -p "Enter your GCP Project ID: " PROJECT_ID

# Confirm
echo "You entered project: $PROJECT_ID"
read -p "Continue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "❌ Aborted."
  exit 1
fi

# Define custom role ID and title
CUSTOM_ROLE_ID="bqCustomSupportRole"
CUSTOM_ROLE_TITLE="BigQuery Custom Support Role"

# Define permissions
PERMISSIONS=(
  "bigquery.tables.get"
  "bigquery.tables.list"
  "bigquery.routines.get"
  "bigquery.routines.list"
  "bigquery.jobs.listAll"
  "bigquery.tables.getData"
)

# Create a temporary JSON file for the role definition
ROLE_FILE=$(mktemp)
cat > "$ROLE_FILE" <<EOF
{
  "title": "$CUSTOM_ROLE_TITLE",
  "description": "Custom role with specific BigQuery permissions for support team.",
  "includedPermissions": [
    $(printf '"%s",\n' "${PERMISSIONS[@]}" | sed '$s/,$//')
  ],
  "stage": "GA"
}
EOF

# Create or update the custom role
echo "🛠️ Creating/updating custom role $CUSTOM_ROLE_ID..."
gcloud iam roles describe "$CUSTOM_ROLE_ID" --project="$PROJECT_ID" >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
  echo "🔁 Role already exists. Updating..."
  gcloud iam roles update "$CUSTOM_ROLE_ID" \
    --project="$PROJECT_ID" \
    --file="$ROLE_FILE"
else
  gcloud iam roles create "$CUSTOM_ROLE_ID" \
    --project="$PROJECT_ID" \
    --file="$ROLE_FILE"
fi

# Bind the role to the group
echo "🔧 Granting custom role to group:bq-support@sela.co.il..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="group:bq-support@sela.co.il" \
  --role="projects/$PROJECT_ID/roles/$CUSTOM_ROLE_ID" \
  --quiet > /dev/null

# Cleanup
rm "$ROLE_FILE"

echo "✅ Custom BigQuery permissions granted successfully to bq-support@sela.co.il on project $PROJECT_ID"
