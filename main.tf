provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

module "s3_website" {
  source = "./modules/s3-website"
}

module "s3_files" {
  source                = "./modules/s3-files"
  downloadCv_lambda_arn = module.lambda_download_cv.lambda_arn
}

module "certificate" {
  source = "./modules/certificate"
}

module "cloudfront_distribution" {
  source            = "./modules/cloudfront"
  website_endpoint  = module.s3_website.website_endpoint
  website_origin_id = module.s3_website.website_origin_id
  certificate_arn   = module.certificate.certificate_arn
}

module "dynamodb_visitor_count" {
  source = "./modules/dynamodb"
}

module "lambda_download_cv" {
  source = "./modules/lambda-cv"
}

module "lambda_visitor_count" {
  source       = "./modules/lambda-visitor"
  dynamodb_arn = module.dynamodb_visitor_count.dynamodb_arn
}

module "api_gateway" {
  source                            = "./modules/api-gateway"
  downloadCv_lambda_function_name   = module.lambda_download_cv.lambda_function_name
  downloadCv_lambda_invoke_arn      = module.lambda_download_cv.lambda_cv_invoke_arn
  visitorCount_lambda_invoke_arn    = module.lambda_visitor_count.lambda_visitor_invoke_arn
  visitorCount_lambda_function_name = module.lambda_visitor_count.lambda_visitor_function_name
}