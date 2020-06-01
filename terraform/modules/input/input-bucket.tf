resource "aws_s3_bucket" "input_bucket" {
  bucket = "input"
  acl    = "private"
}
