resource "gitlab_project" "desafio-devops" {
  name        = var.project_name
  description = var.description

  visibility_level = var.visibility_level
}