// IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_visitor_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

// IAM Role Policy for DynamoDB access (attach to the above role)
resource "aws_iam_role_policy" "lambda_ddb_policy" {
  name = "lambda_visitor_allow_read"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ]
      Resource = [var.dynamodb_arn]
    }]
  })
}

// IAM Role Policy to enable logging (attach to the above role)
resource "aws_iam_role_policy" "lambda_logging_policy" {
  name = "lambda_visitor_enable_logging"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:*:*:*"]
    }]
  })
}

// Create a zip file for the source code
data "archive_file" "file" {
  type        = "zip"
  source_file = "/Users/dibendu/code-workspace/portfolio-visitor-count-lambda/index.mjs"
  output_path = "/Users/dibendu/code-workspace/portfolio-visitor-count-lambda/index.mjs.zip"
}

// Lambda function
resource "aws_lambda_function" "function" {
  filename         = data.archive_file.file.output_path
  source_code_hash = data.archive_file.file.output_base64sha256
  function_name    = "UpdateVisitorCount"
  description      = "This lambda updates and maintains the website visitor count."
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
}

output "lambda_visitor_function_name" {
  value = aws_lambda_function.function.function_name
}

output "lambda_visitor_invoke_arn" {
  value = aws_lambda_function.function.invoke_arn
}