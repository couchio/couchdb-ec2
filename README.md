# CouchDB AMI by couch.io

## "We mind the racks, so you can relax."

Welcome to the couch.io CouchDB Amazon Machine Images. For more information [please visit the web documentation.](http://hosting.couch.io/ami/)

    http://hosting.couch.io/ami/

## Launching an Image

The hardest part of this is installing the EC2 command-line tools, and setting up the proper environment variables. The instructions for installing the EC2 tools are here:

http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351&categoryID=88

To set the environment variables, visit ./bin/couchdb-ec2-env.sh

If you don't want deal with command line stuff, [you can launch CouchDB instances from the couch.io web page:](http://hosting.couch.io/ami/)

The easiest part is launching an instance:

    ./bin/launch-couchdb-instance
    
This will prompt and error, if there are missing environment variables. Once it works, it will spit out the command you need to run to login to your instance.

By default we'll launch a Pro AMI but you can configure the environment to use a public CouchDB AMI. The public AMIs are only slightly cheaper, so we hope you'll use a Pro AMI, so that some of your money goes to couch.io, instead of sending it all to Amazon.

To purchase a pro AMI, visit one of these links:

### CouchDB 0.9.1

[32bit](https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=914F6020)

https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=914F6020

[64bit](https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=BA504E0D)

https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=BA504E0D

### CouchDB 0.10.0

[32bit](https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=FF8C4E12)

https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=FF8C4E12

[64bit](https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=253D99CD)

https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode=253D99CD

To switch to a public AMI, set PAID in the couchdb-ec2-env.sh to "public". Thank you for relaxing, not changing it to "public", and for your support! :)

## Backups

These AMIs are configured to store CouchDB data on the internal, ephemeral storage. This means when your instance terminates, all data will be lost. There are no backups. If you need backups, be sure to set them up. (We plan to add everything from auto-backups to clustering, in future iterations.)

## Security

CouchDB by default is open for all (yay, admin party!), but that's probably not what you want, make sure to secure your CouchDB instance if you plan to use it in production. More information can be found in the Security Chapter of the CouchBook.

To access CouchDB, you'll need to make sure that port 5984 is opened on the AWS firewall for your instance's security group. The documentation for opening ports is maintained by Amazon here. A smart way to control accees (this is how Chris's Blog works) is to set up a security group only available to trusted IP addresses, and then open port 5984 on that. If you want the whole world to be able to read your CouchDB, (which is fine for experimenting) the simple command is: 

    ec2-authorize -p 5984 default

This will open up port 5984 for all instances you boot into the default group. Similarly (some EC2 101 here) if you want to ssh into your CouchDB box, run: 

    ec2-authorize -p 22 default

Don't forget to close port 5984 when you are done: 

    ec2-revoke -p 5984 default

## Creating a Custom Image

To create a new AMI image, edit the S3_BUCKET in couchdb-ec2-env.sh, as well as select the CouchDB version you want to install. Then run:

    ./bin/create-couchdb-instance

This should just work.

## Thanks

These scripts are based heavily on work by Eric Hammond, available in the Hadoop project.

### History:

* 2008-05-16 Eric Hammond <ehammond@thinksome.com>
  - Initial version including code from Kim Scheibel, Jorge Oliveira
* 2008-08-06 Tom White
  - Updated to use mktemp on fedora
* 2009-09-29 Chris Anderson <jchris@couch.io>
  - Updated for Ubuntu and CouchDB


## License: Apache 2.0
  http://www.apache.org/licenses/LICENSE-2.0
