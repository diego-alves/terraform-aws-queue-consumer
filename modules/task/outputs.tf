output "image_url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "Docker Image url"
}
