## Terraform AWS Infrastructure
This repository is part of the AWS Cloud Resume Challenge - <br />
https://cloudresumechallenge.dev/docs/the-challenge/aws/

This code repository contains terraform configurations that deploys and manages multiple AWS services required to host and support my website - <br />https://dibendusaha.com/
<br />
<br />

## Technicals
The terraform configuration sets up the AWS <ins>**S3**</ins> bucket that hosts my website files, and an Amazon <ins>**CloudFront**</ins> distribution that serves my website to the end users.

End users can download and view my resume, and hence the configuration sets up another AWS <ins>**S3**</ins> bucket which holds my CV. It also sets up an AWS <ins>**Lambda**</ins> and an Amazon <ins>**API Gateway**</ins> via which the CV is served.

End users can also see their visit queue position, for which the terraform configuration creates an Amazon <ins>**DynamoDB**</ins> table that records the visitor count. To update and retrieve the data, terraform sets up another AWS <ins>**Lambda**</ins> which queries the count and sends back the data via the Amazon <ins>**API Gateway**</ins> that it created earlier.

<br />

## Architecture
<br />

![portfolio-aws-infra-2 (transparent bg)](https://github.com/user-attachments/assets/a6d82af3-3f29-4b04-ac52-b8083b3c001f)
