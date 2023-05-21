#!/bin/bash

BUCKET_NAME="testshellscriptfordeletefileins3"
CURRENT_DATE=$(date +"%d-%m-%Y")
DATE_90_AGO=$(date -d "90 days ago" +"%Y-%m-%d" | tr -d '-')

aws s3 ls s3://$BUCKET_NAME | awk '{print $2}' >> s3bucketfiles.txt

# Declare an empty array
declare -a S3_BUCKET_CONTANT

# Read the lines of the text file into the array
mapfile -t S3_BUCKET_CONTANT < "s3bucketfiles.txt"

for line in "${S3_BUCKET_CONTANT[@]}"; do
    echo "$line"
    aws s3 ls s3://$BUCKET_NAME/$line | awk '{print $2}' >> dir.txt
    declare -a S3_DIR2_CONTANT
    mapfile -t S3_DIR2_CONTANT < "dir.txt"
    for FILE_DATE in "${S3_DIR2_CONTANT[@]}"; do
    	FILE_DATE_WITHOUT_FORWARDSLASH=$(echo "$FILE_DATE" | tr -d '/')
    	FILE_DATE_WITHOUT_MINUS=$(busybox date -D %d-%m-%Y -d "$FILE_DATE_WITHOUT_FORWARDSLASH" +%F | tr -d '-') 

    	if [[ $DATE_90_AGO > $FILE_DATE_WITHOUT_MINUS ]]; then
             aws s3 rm s3://$BUCKET_NAME/$line$FILE_DATE
            echo $FILE_DATE "this file is delete";
		else
    		echo "in 90 days" $FILE_DATE;
		fi
    done
    rm ./dir.txt
done
rm s3bucketfiles.txt
