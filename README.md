## Terraform AWS Infrastructure
This repository is part of the AWS Cloud Resume Challenge - <br />
https://cloudresumechallenge.dev/docs/the-challenge/aws/

This code repository contains terraform configurations that deploys and manages multiple AWS services required to host and support my website - <br />https://dibendusaha.com/
<br />
<br />

## AWS Resources Involved
- IAM
- S3
- CloudFront
- API Gateway
- Lambda
- DynamoDB
- AWS Certificate Manager
<br />

## Technicals
The terraform configuration sets up the AWS <ins>**S3**</ins> bucket that hosts my website files, which sits behind Amazon <ins>**CloudFront**</ins> that serves my website to the end users globally.

End users can download and view my resume, and hence the configuration sets up another AWS <ins>**S3**</ins> bucket which holds my CV. It also sets up an AWS <ins>**Lambda**</ins> and an Amazon <ins>**API Gateway**</ins> via which the CV is served.

End users can also see their visit queue position, for which the terraform configuration creates an Amazon <ins>**DynamoDB**</ins> table that records the visitor count. To update and retrieve the data, terraform sets up another AWS <ins>**Lambda**</ins> which queries the count and sends back the data via the Amazon <ins>**API Gateway**</ins> that it created earlier.

<br />

## Architecture
<br />


![Portfolio AWS Architecture](https://github.com/user-attachments/assets/4195706e-bcac-4844-be16-fe314762ba2a)
