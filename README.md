## Terraform AWS Infrastructure

This repository is part of the AWS Cloud Resume Challenge - <br />https://cloudresumechallenge.dev/docs/the-challenge/aws/
<br />
This code repository contains terraform configurations that deploys and manages multiple AWS services required to host and support my website - <br />https://dibendusaha.com/
<br />
My website is hosted in an AWS **S3** bucket that is served to users via an Amazon **CloudFront** distribution.

End users can download and view my resume which is stored in another AWS **S3** bucket and is served to users via AWS **Lambda** and an Amazon **API Gateway**.

End users can also see their visit queue position. This data is stored in a Amazon **DynamoDB** database and is served to users via another AWS **Lambda** and the Amazon **API Gateway**.

<br />

![portfolio-aws-infra-2 (transparent bg)](https://github.com/user-attachments/assets/a6d82af3-3f29-4b04-ac52-b8083b3c001f)
