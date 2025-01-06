resource "aws_iam_role" "lambda_role" {
name   = "api_proxy_lambda_role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 name         = "api_proxy_lambda_policy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api_proxy_lambda_policy_role_attach" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_api_proxy_lambda_code" {
type        = "zip"
source_dir  = "${path.module}/../lambda_function/"
output_path = "${path.module}/../lambda_function/api_lambda_proxy.zip"
}

data "archive_file" "zip_api_proxy_validation_lambda_layer" {
type        = "zip"
source_dir  = "${path.module}/../nodejs"
output_path = "${path.module}/../nodejs/api_proxy_validation_lambda_layer.zip"
}

resource "aws_lambda_layer_version" "api_proxy_validation_layer" {
  filename   = "${path.module}/../nodejs/api_proxy_validation_lambda_layer.zip"
  layer_name = "api_proxy_validation_lambda_layer"

  compatible_runtimes = ["nodejs16.x", "nodejs20.x"]
}

resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/../lambda_function/api_lambda_proxy.zip"
source_code_hash = filebase64sha256("${path.module}/../lambda_function/api_lambda_proxy.zip")
function_name                  = "api_proxy"
role                           = aws_iam_role.lambda_role.arn
handler                        = "test.myhandler"
runtime                        = "nodejs20.x"
depends_on                     = [aws_iam_role_policy_attachment.api_proxy_lambda_policy_role_attach]
layers = [ aws_lambda_layer_version.api_proxy_validation_layer.arn ]
}