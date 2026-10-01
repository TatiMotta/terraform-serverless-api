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
