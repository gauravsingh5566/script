#!/bin/bash

BUCKET_NAME="tests3deletefilebyshell"
DATE_90_AGO=$(date -d "90 days ago" +"%Y-%m-%d" | tr -d '-')

check_date_format() {
    local date_string="$1"

    # Extract day, month, and year from the date string
    day=$(echo "$date_string" | cut -d '-' -f 1)
    month=$(echo "$date_string" | cut -d '-' -f 2)
    year=$(echo "$date_string" | cut -d '-' -f 3)

    # Validate the date format
    if [[ $date_string =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]] && \
       date -d "$year-$month-$day" >/dev/null 2>&1; then
        dateconfirm=1
    else
        echo "Invalid date format: $date_string"
        dateconfirm=0
    fi
}

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
    
    for LINE2 in "${S3_DIR2_CONTANT[@]}"; do
        echo "$LINE2"
        aws s3 ls s3://$BUCKET_NAME/$line$LINE2 | awk '{print $2}' >> dir2.txt
        declare -a S3_DIR3_CONTANT
        mapfile -t S3_DIR3_CONTANT < "dir2.txt"
       
        for FILE_DATE in "${S3_DIR3_CONTANT[@]}"; do
            FILE_DATE_WITHOUT_FORWARDSLASH=$(echo "$FILE_DATE" | tr -d '/')
            check_date_format "$FILE_DATE_WITHOUT_FORWARDSLASH"
            if [[ $dateconfirm == 1 ]]; then
                FILE_DATE_WITHOUT_MINUS=$(busybox date -D %d-%m-%Y -d "$FILE_DATE_WITHOUT_FORWARDSLASH" +%F | tr -d '-') 
                if [[ $DATE_90_AGO > $FILE_DATE_WITHOUT_MINUS ]]; then
                    aws s3 rm s3://$BUCKET_NAME/$line$LINE2$FILE_DATE --recursive
                    echo -e "\033[31m$BUCKET_NAME/$line$LINE2$FILE_DATE this file is deleted\033[0m";
                else
                    echo -e "\033[32mIN 90 days $BUCKET_NAME/$line$LINE2$FILE_DATE\033[0m";
                fi
            else
                 echo $FILE_DATE_WITHOUT_FORWARDSLASH "this is not date directory" ;   
            fi 
        done	
        rm ./dir2.txt    
    done
    rm ./dir.txt
done
rm s3bucketfiles.txt


 
