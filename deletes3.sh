BUCKET_NAME="us2-tf-backend-z3zu58asipvf7dtosxgeqm8cfgmt8udx"

# List all object versions and delete them
aws s3api list-object-versions --bucket $BUCKET_NAME --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' --output=json > objects.json

# Check if objects.json is not empty
if [ -s objects.json ]; then
    aws s3api delete-objects --bucket $BUCKET_NAME --delete file://objects.json
fi

# List all delete markers and delete them
aws s3api list-object-versions --bucket $BUCKET_NAME --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' --output=json > delete-markers.json

# Check if delete-markers.json is not empty
if [ -s delete-markers.json ]; then
    aws s3api delete-objects --bucket $BUCKET_NAME --delete file://delete-markers.json
fi

# Clean up temporary files
rm -f objects.json delete-markers.json
