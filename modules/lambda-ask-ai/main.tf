// IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_ask_ai_execution_role"
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

// IAM Role Policy to enable logging (attach to the above role)
resource "aws_iam_role_policy" "lambda_logging_policy" {
  name = "lambda_ask_ai_enable_logging"
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
  source_dir  = "/Users/dibendu/code-workspace/portfolio-ask-ai-lambda"
  output_path = "/Users/dibendu/code-workspace/portfolio-ask-ai-lambda/function.zip"
  excludes    = [".git", "function.zip"]
}

// Lambda function
resource "aws_lambda_function" "function" {
  filename         = data.archive_file.file.output_path
  source_code_hash = data.archive_file.file.output_base64sha256
  function_name    = "AskAI"
  description      = "This lambda talks to AI and answer user queries."
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  timeout          = 30
}

output "lambda_ask_ai_function_name" {
  value = aws_lambda_function.function.function_name
}

output "lambda_ask_ai_invoke_arn" {
  value = aws_lambda_function.function.invoke_arn
}