# abort-s3-multipart

This bash script can be used to find the unaborted multipart files you have that are stucked in all your Amazon S3 buckets (that you are paying storage for but are unusable and not showing in your buckets).

It will exclude today's (using today's date from your system) incomplete multipart(s) to make sure to not delete currently uploading multipart files.

### Prerequisites

This script uses the aws-cli from Amazon with your current configuration, you don't need to add or configure anything in the script itself as long as your aws-cli works already.

So...

 - You need the aws-cli from Amazon.
 - You need to have aws-cli already configured and working with your keys.

```
https://docs.aws.amazon.com/cli/latest/userguide/installing.html
```

### Installing

To run this script, just git clone this repo (or download the script only), and run the script.

```
bash abort-s3-multipart.bash
```

Do a "dry-run" to see what would be done (no abort / cleanup will be done in this mode, it will only show you what would be done and the commands it would run. So you can test a command by yourself instead of having the script do it for you).

```
bash abort-s3-multipart.bash -d
```

You can also make the script analyze only 1 bucket instead of all of them (still in dry-run mode only)

```
bash abort-s3-multipart.bash -d -b bucketname
```

When you are satisfied with what you see and you want the script to cleanup all the stucked multiparts, either run the commands the script showed you by yourself OR use the command -R instead of -d (check explanation from the help -h) to have the script run the commands for you to cleanup (delete) the incomplete multipart(s) upload in Amazon.

## Authors

* **Patrick Monfette** - *Initial work* - [RedVortex](https://github.com/RedVortex)

## License

No license, use this script as you want, feel free to make money out of it. It actually saved me a lot of money when I discovered all those stucked multipart files in Amazon that have been there for years and I was paying for this storage without me knowing :-)

## Acknowledgments

Thanks to [Refael Ackermann](https://stackoverflow.com/users/27955/refael-ackermann) for the jq parsing I reused here that I found on [StackOverflow](https://stackoverflow.com/a/39457459/10192912)
