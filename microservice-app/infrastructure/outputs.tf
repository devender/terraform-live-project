output "ecr_arn" {
  value = aws_ecr_repository.myecr.arn
  #arn:aws:ecr:us-west-2:324671914464:repository/microservice-sample-ecr
}

output "ecr_repository_url" {
  value = aws_ecr_repository.myecr.repository_url
  #324671914464.dkr.ecr.us-west-2.amazonaws.com/microservice-sample-ecr
}

