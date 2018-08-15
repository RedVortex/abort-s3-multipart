# abort-s3-multipart

This bash script can be used to find the unaborted multipart files you have that are stucked in all your Amazon S3 buckets (that you are paying storage for but are unusable and not showing in your buckets).

It will exclude today's (using today's date from your system) incomplete multipart to make sure to not delete currently uploading multipart files.

### Prerequisites

This script uses the aws-cli from Amazon with your current configuration, you don't need to add or configure anything in the script itself as long as your aws-cli works already.

So...

 - You need the aws-cli from Amazon.
 - You need to have it already configured and working with your keys.

```
https://docs.aws.amazon.com/cli/latest/userguide/installing.html
```

### Installing

To run this script, jJust git clone this repo, and run the script.

```
bash abort-s3-multipart.bash
```

It will tell you you need an option, run it again using -h (as the output says)

```
bash abort-s3-multipart.bash -h
```

Do a "dry-run" to see what would be done (no delete or cleanup will be done, it will only show you what would be done and the commands it would run

```
bash abort-s3-multipart.bash -d
```

When you are satisfied, either run the commands the script showed you yourself or use the command (from the help -h) to have the script run the commands for you to cleanup (delete) the incomplete multipart upload in Amazon.

## Authors

* **Patrick Monfette** - *Initial work* - [RedVortex](https://github.com/RedVortex)

## License

No license, use this script as you want, feel free to make money out of it. It actually saved me a lot of money when I discovered all those stucked multipart files in Amazon that have been there for years and I was paying for this storage without me knowing :-)

## Acknowledgments

Thanks to [Refael Ackermann](https://stackoverflow.com/users/27955/refael-ackermann) for the jq parsing I reused here that I found on [StackOverflow](https://stackoverflow.com/questions/39457458/howto-abort-all-incomplete-multipart-uploads-for-a-bucket)
