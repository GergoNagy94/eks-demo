resource "aws_s3_bucket" "gergo_test_bucket_1" {
    bucket = "gergo_test_bucket_1"
}

resource "aws_kms_key" "getgo_test_key" {
  description = "gergo_test_key"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_acl" "gergo_test_acl" {
  bucket = aws_s3_bucket.gergo_test_bucket_1.id
  acl = "private"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.gergo_test_bucket_1.id
  key = "g_object_key"
  source = "./practice/hello.txt"
  kms_key_id = aws_kms_key.getgo_test_key.arn

  etag = filemd5("./practice/hello.txt")
}

resource "aws_s3_bucket" "gergo_test_bucket_2" {
    bucket = "gergo_test_bucket"
}

import {
  to = aws_s3_object.object
  id = "some-bucket-name/some/key.txt"
}