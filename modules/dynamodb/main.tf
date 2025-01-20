resource "aws_dynamodb_table" "table" {
  name         = "PortfolioVisitorCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "TotalCount"

  attribute {
    name = "TotalCount"
    type = "N"
  }
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.table.arn
}