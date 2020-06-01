resource "aws_lambda_event_source_mapping" "input_queue_to_input_processor_lambda" {
  event_source_arn = aws_sqs_queue.input_queue.arn
  function_name    = aws_lambda_function.input_processor_lambda.arn
}
