resource "aws_iam_role" "input_processor_lambda_role" {
  name = "input_processor_lambda_policy"
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

resource "aws_lambda_function" "input_processor_lambda" {
  filename      = "../../target/input-processor.zip"
  function_name = "input-processor-lambda"
  role          = aws_iam_role.input_processor_lambda_role.arn
  handler       = "input_processor.handle_event"
  source_code_hash = filebase64sha256("../../target/input-processor.zip")
  runtime = "python3.8"
}
