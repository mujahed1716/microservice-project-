resource "aws_ecr_repository" "app" {
  name = "microservice-app"
}

resource "null_resource" "docker_push" {

  provisioner "local-exec" {
    command = <<EOT
cd ../docker

aws ecr get-login-password --region eu-north-1 | \
docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}

docker build -t app .

docker tag app:latest ${aws_ecr_repository.app.repository_url}:latest

docker push ${aws_ecr_repository.app.repository_url}:latest
EOT
  }

  depends_on = [aws_ecr_repository.app]
}
