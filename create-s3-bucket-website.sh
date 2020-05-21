#!/bin/bash

echo -ne '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::preeti-covid-stats/*"
        }
    ]
}' > bucket_policy.json

aws s3api create-bucket --bucket preeti-covid-stats --region eu-west-2  --create-bucket-configuration LocationConstraint=eu-west-2 --profile default \
  && aws s3api put-bucket-policy --bucket preeti-covid-stats --policy file://./bucket_policy.json --profile default \
  && aws s3 sync ../CovidStats s3://preeti-covid-stats/  --profile default \
  && aws s3 website s3://preeti-covid-stats/ --index-document index.html --error-document error.html --profile default