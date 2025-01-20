resource "aws_api_gateway_rest_api" "api" {
  name = "PortfolioApiGateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# ********************************************** #
# ************ DOWNLOAD CV RESOURCE ************ #
# ********************************************** #
resource "aws_api_gateway_resource" "resource_cv" {
  path_part   = "download-cv"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "get_cv" {
  http_method   = "GET"
  authorization = "NONE"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource_cv.id
}

resource "aws_api_gateway_integration" "integration_cv" {
  type                    = "AWS_PROXY"
  http_method             = aws_api_gateway_method.get_cv.http_method
  integration_http_method = "POST"
  uri                     = var.downloadCv_lambda_invoke_arn
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource_cv.id
}

resource "aws_lambda_permission" "lambda_cv_permission" {
  statement_id  = "allow_invoke_from_api_gateway"
  action        = "lambda:InvokeFunction"
  function_name = var.downloadCv_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


# ********************************************** #
# *********** VISITOR COUNT RESOURCE *********** #
# ********************************************** #
resource "aws_api_gateway_resource" "resource_visitor" {
  path_part   = "visitor-count"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "get_count" {
  http_method   = "ANY"
  authorization = "NONE"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource_visitor.id
}

resource "aws_api_gateway_integration" "integration_visitor" {
  type                    = "AWS_PROXY"
  http_method             = aws_api_gateway_method.get_count.http_method
  integration_http_method = "POST"
  uri                     = var.visitorCount_lambda_invoke_arn
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource_visitor.id
}

resource "aws_lambda_permission" "lambda_visitor_permission" {
  statement_id  = "allow_invoke_from_api_gateway"
  action        = "lambda:InvokeFunction"
  function_name = var.visitorCount_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


# ********************************************** #
# *************** COMMON RESOURCE ************** #
# ********************************************** #
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.integration_cv,
    aws_api_gateway_integration.integration_visitor
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}




# ********************************************** #
# ********************************************** #
# ************* CORS configuration ************* #
# ********************************************** #
# ********************************************** #

# OPTIONS method for CORS
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource_visitor.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# OPTIONS method response
resource "aws_api_gateway_method_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_visitor.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# OPTIONS integration
resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_visitor.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Add CORS headers to OPTION integration response
resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_visitor.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.integration_visitor
  ]
}
