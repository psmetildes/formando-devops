resource "shell_script" "install" {
  lifecycle_commands {
    create = file("${path.module}/scripts/install.sh")
    delete = file("${path.module}/scripts/remove.sh")
  }

  environment = {
    PKG_NAME        = var.pkg_name
  }
}
