# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# utility functions
require_var()
{
  var=$1
  name=$2
  if [ -z "$var" ]; then
    echo "ERROR:"
    echo "  Missing environment variable \"$name\""
    echo ""
    echo "Exiting"
    exit 2
  fi
}

# COUCHDB_SVN=http://svn.apache.org/repos/asf/couchdb/tags/0.9.1
# COUCHDB_VERSION=0.9.1

COUCHDB_SVN=http://svn.apache.org/repos/asf/couchdb/branches/0.10.x
COUCHDB_VERSION=0.10.x

# The EC2 instance type: m1.small, m1.large, m1.xlarge
INSTANCE_TYPE="m1.small"
# INSTANCE_TYPE="m1.large"
# INSTANCE_TYPE="m1.xlarge"

# set this to your own bucket if you are custom building one
S3_BUCKET=jchris-couchdb

# group to run instances under
EC2_GROUP=default

require_var "$EC2_KEY_NAME" "EC2_KEY_NAME"
require_var "$EC2_PRIVATE_KEY" "EC2_PRIVATE_KEY"
require_var "$AWS_ACCOUNT_ID" "AWS_ACCOUNT_ID"
require_var "$AWS_ACCESS_KEY_ID" "AWS_ACCESS_KEY_ID"
require_var "$AWS_ACCESS_KEY_ID" "AWS_ACCESS_KEY_ID"

EC2_KEYDIR=`dirname "$EC2_PRIVATE_KEY"`
echo "using EC2_KEYDIR $EC2_KEYDIR"

# Where your EC2 private key is stored (created when following the Amazon Getting Started guide).
# You need to change this if you don't store this with your other EC2 keys.
PRIVATE_KEY_PATH=`echo "$EC2_KEYDIR"/"id_rsa-$EC2_KEY_NAME"`
echo "using ec2 ssh key: $PRIVATE_KEY_PATH"

# TODO ensure id_rsa file permssions are 0600

# SSH options used when connecting to EC2 instances.
SSH_OPTS=`echo -i "$PRIVATE_KEY_PATH" -o StrictHostKeyChecking=no -o ServerAliveInterval=30`

# Ubuntu 9.10 http://uec-images.ubuntu.com/releases/karmic/release/
if [ "$INSTANCE_TYPE" == "m1.small" ]; then
  ARCH='i386' # 32 bit
  BASE_AMI_IMAGE='ami-1515f67c' # us 32 bit
  # BASE_AMI_IMAGE='ami-a62a01d2' europe
else
  ARCH='x86_64' # 64 bit
  BASE_AMI_IMAGE="ami-ab15f6c2"  # us
  # BASE_AMI_IMAGE='ami-9a2a01ee' europe
fi

REQUIRED_BINARIES="\
  ec2-describe-images \
  ec2-describe-instances \
  ec2-run-instances \
  ec2-terminate-instances \
  ec2-register \
  ec2-deregister \
  ec2-authorize"

for binary in $REQUIRED_BINARIES; do
  if [ ! -x "$EC2_HOME/bin/$binary" ]; then
    echo "ERROR:"
    echo "  Command \"$binary\" not found. Did you install the EC2-Utilities?"
    echo "  Get them from:"
    echo "  http://docs.amazonwebservices.com/AWSEC2/latest/GettingStartedGuide/StartCLI.html"
    echo ""
    echo "Exiting."
    exit 1
  fi
done
