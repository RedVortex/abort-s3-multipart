#!/bin/bash

doit=0

trap ctrl_c INT

function ctrl_c() {
        echo "CTRL-C pressed, aborting..."
	exit 1;
}

show_help () {
cat << EOF
Usage:

bash abort-s3-multipart.bash [OPTION]

Options:
	-d	Dry run (Show what would be done)
	-R	Really do it, don't just show what would be done
	-h	This help
EOF
exit 1
}

bad_options () {
echo "Missing or invalid option: use -h for help"
exit 1
}

while getopts ":Rdh" opt; do
    case "$opt" in
    R)  doit=1
        ;;
    d)  doit=0
        ;;
    \?) bad_options
        ;;
    h)	show_help
        ;;
    esac
done

if [[ "$OPTIND" == "1" ]]; then
       	bad_options
fi

echo "Gathering all S3 buckets..."
BUCKETS="$(aws s3api list-buckets | jq '.Buckets[] | (.Name)' | cut -d\" -f 2)"
echo "Done!"

for BUCKETNAME in ${BUCKETS}; do
	echo "Checking bucket $BUCKETNAME for incomplete multiparts excluding today's date..."
	aws s3api list-multipart-uploads --bucket $BUCKETNAME  |\
	jq -r '.Uploads[] | "--key \"\(.Key)\" --upload-id \(.UploadId)#\(.Initiated)"' |\
       	grep -v "$(date "+%Y-%m-%d")" |\
	cut -d# -f 1 |\
	while read line; do
    		echo "Found incomplete multipart: $line"
		if [[ "$doit" == "1" ]]; then
			echo "Aborting multipart..."
	      		eval "aws s3api abort-multipart-upload --bucket $BUCKETNAME $line"
		else
			echo "Here's the command to abort the multipart (not doing it for you)..."
			echo "aws s3api abort-multipart-upload --bucket $BUCKETNAME $line"
		fi
	done
done
