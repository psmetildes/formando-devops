terraform {
  required_providers {
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

resource "local_file" "create_file" {
  content = templatefile( 
    "${path.module}/templates/alo_mundo.txt.tpl", { 
      nome = "${var.nome}",
      data = formatdate("DD, M, YYYY","${timestamp()}"), 
      div = "${var.numero_divisor}",
      #resto = yamlencode([ for x in range(0, 100 ) : x if x%var.numero_divisor == 0])
      resto = jsonencode([ for x in range(0, 100 ) : x if x%var.numero_divisor == 0])
    } 
  )  

  filename = "${path.module}/files/alo_mundo.txt"
  
}