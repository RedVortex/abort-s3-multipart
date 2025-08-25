#!/bin/bash

BUCKETS=""
doit=0
# SET ANSI Colors to use in output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color -  Reset to default

trap ctrl_c INT

function ctrl_c() {
  echo "CTRL-C pressed, aborting..."
  exit 1;
}

show_help () {
cat << EOF
Usage:

bash abort-s3-multipart.bash [OPTION] [-b bucketname]

Options:
	-d	Dry run (Show what would be done)
	-R	Really do it, don't just show what would be done
	-b	Bucket to check, check all buckets if option is absent
	-h	This help
EOF
exit 1
}

while getopts "Rdhb:" opt; do
  case "$opt" in
    R)  doit=1
        ;;
    d)  doit=0
        echo -ne "${YELLOW}Will only list commands to abort multiparts and not delete them since dry run enabled${NC}\n\n"
        ;;
    b)  BUCKETS=${OPTARG}
        ;;
    *) show_help
        ;;
  esac
done

if [[ "$OPTIND" == "1" ]]; then
  show_help
fi

if [[ "$BUCKETS" == "" ]];
  then
    echo -ne "Gathering S3 buckets... "
    BUCKETS="$(aws s3api list-buckets | jq -r '.Buckets[] | (.Name)')"
    echo -ne "${GREEN}Done!${NC}\n\n"
fi

EXCLUDE_DATE="$(date "+%Y-%m-%d")"
echo -ne "${YELLOW}Excluding ${EXCLUDE_DATE} incomplete multiparts from checks.${NC}\n\n"

for BUCKETNAME in ${BUCKETS}; do
  echo "Checking bucket $BUCKETNAME..."
  aws s3api list-multipart-uploads --bucket $BUCKETNAME |\
  jq -r 'try.Uploads[] | "--key \"" + .Key + "\" --upload-id " + .UploadId + "\t# " + .Initiated' |\
  grep -v ${EXCLUDE_DATE} |\
  column -t |\
  while read line; do
    if [[ "$doit" == "1" ]]; then
      echo -ne "\t${RED}Aborting incomplete multipart: $(echo $line | cut -d\" -f2)${NC}\n"
      eval "aws s3api abort-multipart-upload --bucket $BUCKETNAME $line"
    else
      echo -ne "\t${RED}aws s3api abort-multipart-upload --bucket $BUCKETNAME $line${NC}\n"
    fi
  done
done
