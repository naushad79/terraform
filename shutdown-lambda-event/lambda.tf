data "aws_iam_policy_document" "lambda_assum_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "stop_start_ec2" {
  statement {
    effect = "Allow" 
    actions = [
        "ec2:StartInstances",
        "ec2:StopInstances",
    ]

    resources = [
        "arn:aws:ec2:*:*:instance/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Owner"

      values = [
        "$${aws:username}"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [ "ec2:DescribeInstances" ]
    resources = ["*"] 
  }
}

resource "aws_iam_policy" "stop_start_ec2" {
  policy = data.aws_iam_policy_document.stop_start_ec2.json
}

resource "aws_iam_role" "lambda_role" {  
  name = "lambda-role-ec2-stop-start"  
  assume_role_policy = data.aws_iam_policy_document.lambda_assum_role_policy.json
  managed_policy_arns = [aws_iam_policy.stop_start_ec2.arn]
}

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/scripts/lambda_function.py" 
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda_function" {
    function_name = "lambdaTest"
    filename      = "lambda_function.zip"
    source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
    role          = aws_iam_role.lambda_role.arn
    runtime       = "python3.8"
    handler       = "lambda_function.lambda_handler"
    timeout       = 10
}