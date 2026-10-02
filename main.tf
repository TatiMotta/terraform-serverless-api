resource "aws_dynamodb_table" "products" {
  name         = "tatiana-${var.project_name}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "tatiana-${var.project_name}-${var.environment}"
  }
}

resource "aws_lambda_function" "products_api" {
  function_name = "${var.resource_prefix}-${var.project_name}-${var.environment}"
  runtime       = var.lambda_runtime
  handler       = "lambda_function.lambda_handler"

  filename         = "lambda/lambda_function.zip"
  source_code_hash = filebase64sha256("lambda/lambda_function.zip")

  memory_size = var.lambda_memory
  timeout     = var.lambda_timeout

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.products.name
    }
  }

  tags = {
    Name = "${var.resource_prefix}-${var.project_name}-${var.environment}"
  }
}
