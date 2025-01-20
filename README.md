## Terraform AWS Infrastructure

This repository is part of the AWS Cloud Resume Challenge - <br />
https://cloudresumechallenge.dev/docs/the-challenge/aws/

This code repository contains terraform configurations that deploys and manages multiple AWS services required to host and support my website - <br />https://dibendusaha.com/

The terraform configuration sets up the AWS **S3** bucket that hosts my website files, and an Amazon **CloudFront** distribution that serves my website to the end users.

End users can download and view my resume, and hence the configuration sets up another AWS **S3** bucket which holds my CV. It also sets up an AWS **Lambda** and an Amazon **API Gateway** via which the CV is served.

End users can also see their visit queue position, for which the terraform configuration creates an Amazon **DynamoDB** table that records the visitor count. To update and retrieve the data, terraform sets up another AWS **Lambda** which queries the count and sends back the data via the Amazon **API Gateway** that it created earlier.

<br />

![portfolio-aws-infra-2 (transparent bg)](https://github.com/user-attachments/assets/a6d82af3-3f29-4b04-ac52-b8083b3c001f)
