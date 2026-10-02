resource "aws_iam_role" "lambda" {
  name = "tatiana-${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "tatiana-${var.project_name}-${var.environment}-lambda-role"
  }
}

resource "aws_iam_policy" "lambda" {
  name = "tatiana-${var.project_name}-${var.environment}-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]

        Resource = aws_dynamodb_table.products.arn
      }
    ]
  })

  tags = {
    Name = "tatiana-${var.project_name}-${var.environment}-lambda-policy"
  }
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
