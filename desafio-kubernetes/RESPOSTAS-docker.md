# Desafio Docker

1. Executado o comando `hostname` na imagem `alpinie:3.16` e utilizado o parâmetro --rm para remover o container após a execução

```bash
docker container run --rm --hostname desafio_docker alpine:3.16 hostname
docker container ls -a
```
2. Crie um container com a imagem `nginx` (versão 1.22), expondo a porta 80 do container para a porta 8080 do host.

```bash
docker container run -d --name nginx --hostname nginx 8080:80 nginx:1.22
```

3. Faça o mesmo que a questão anterior (2), mas utilizando a porta 90 no container. O arquivo de configuração do nginx deve existir no host e ser read-only no container.

```bash
docker container run -d --name webserver --hostname webserver --mount type=volume,src=config_nginx,dst=/etc/nginx,ro -p 90:80 nginx:1.22
```

4. Construa uma imagem para executar o programa abaixo:

```
vim run.py
```

```python
def main():
   print('Hello World in Python!')

if __name__ == '__main__':
  main()
```

```bash
vim Dockerfile

FROMT alpine:3.16

RUN apk add --no-cache python3 

WORKDIR app 

COPY run.py /app

CMD ["/usr/bin/python3", "run.py"]

```

```bash 
docker build -t desafio-docker:1.0 .
docker container run --rm desafio-docker:1.0
``` 

5. Execute um container da imagem `nginx` com limite de memória 128MB e 1/2 CPU.

```bash
docker container run -d --name webserver-limitado --memory 128M --cpus 0.5 nginx:1.22
```

6. Qual o comando usado para limpar recursos como imagens, containers parados, cache de build e networks não utilizadas?

```bash
docker image prune
docker container prune
docker network prune
```

7. Como você faria para extrair os comandos Dockerfile de uma imagem?

```bash
docker image inspect alpine:3.13.5 | egrep -i "entrypoint|cmd"
```
