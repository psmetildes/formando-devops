# Desafio Kubernetes

1 - Linha de comando  para capture somente linhas que contenham "erro" do log do pod `serverweb` no namespace `meusite` com label `app: ovo`.

```bash
  $ kubectl logs -f -l app=ovo -n meusite | grep -i error --color
```
</br> 

2 - Foi criado um manifesto utilizando o `DaemonSet` para executar em todos os nós do cluster com a imagem `nginx:latest` com nome `meu-spread` e utilizando o `tolerations` para não alterar o taint.

[meu-spread.yaml](arquivos/Resposta-2/meu-spread.yaml)

</br> 

3 - Criado um deploy chamado `meu-webserver` com a imagem `nginx:latest` e um initContainer com a imagem `alpine`. O initContainer cria um arquivo `index.html` no diretório `/app` com o conteúdo "HelloGetup" para compartilhar o arquivo com o container de nginx utilizado `volumes`.

[meu-webserver.yaml](arquivos/Resposta-3/meu-webserver.yaml)

</br> 

4 - Criado um deploy chamado `meuweb` com a imagem `nginx:1.16` com `nodeSelector` e utilizando `tolerations`.

```bash
  $ kubectl create label nodes master app=meuweb
  $ kubectl create -f meuweb.yaml
```
[meuweb.yaml](arquivos/Resposta-4/meuweb.yaml)

</br> 

5 - Comandos para altere a imagem do pod `meuweb` para `nginx:1.19` 

```bash
  $ kubectl patch pod meuweb-55bb5d9c47-njv9t -p '{spec:{containers:[{image:nginx:1.19 }]}}'
  $ kubectl set image pod meuweb-55bb5d9c47-njv9t nginx=nginx:1.19
```
</br> 

6 - quais linhas de comando para instalar o ingress-nginx controller usando helm, com os seguintes parametros;
```
    helm repository :   

    values do ingress-nginx : 
    controller:
      hostPort:
        enabled: true
      service:
        type: NodePort
      updateStrategy:
        type: Recreate
```
  6.1 - Instalanção do chart ingress-nginx passando parâmetros:

  ```bash
    $ helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace \
    --set controller.hostPort.enabled=true \
    --set controller.service.type=NodePort \
    --set controller.updateStrategy.type=Recreate
  ```
</br> 

7 - Comando para criar um deploy chamado `pombo` com a imagem de `nginx:1.11.9-alpine` com 4 réplicas;
  ```bash
    $  kubectl create deployment pombo --image=nginx:1.11.9-alpine --replicas=4
  ```

  7.1 - Alterando a imagem para `nginx:1.16` e registrando na annotation automaticamente;
  ```bash
    $ kubectl patch deployments.apps pombo -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.16"}]}}}}'
  ```
  
  7.2 - Alterando a imagem para 1.19 e registrando novamente; 
  ```bash
    $ kubectl patch deployments.apps pombo -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.19"}]}}}}'
  ```
    
  7.3 - Imprimir a histórico de alterações desse deploy;
  ```bash
    $ kubectl rollout history deployment pombo
  ```

  7.4 - Voltar para versão 1.11.9-alpine baseado no historico que voce registrou.

  ```bash
    $ kubectl rollout undo deployment pombo --to-revision=1
  ```
  7.5 - Criar um ingress chamado `web` para esse deploy `REVISAR`

  ```bash
    $ helm install web --set rbac.create=true ingress-nginx/ingress-nginx
  ```

</br> 

8 - Linha de comando para criar um deploy chamado `guardaroupa` com a imagem `redis`;
  ```bash
    $ kubectl create deployment guardaroupa --image=redis --port 6379
  ```

  8.1 - Linha de comando para criar um serviço do tipo ClusterIP desse redis com as devidas portas.

  ```bash
    $ kubectl expose deployment guardaroupa --type=ClusterIP --port 6379
  ```

</br>

9 - Criado um recurso para aplicação stateful com os seguintes parametros:

    - nome : meusiteset
    - imagem nginx 
    - no namespace backend
    - com 3 réplicas
    - disco de 1Gi
    - montado em /data
    - sufixo dos pvc: data

  [namespace.yml](arquivos/Resposta-9/namespace.yml)</br>
  [pv-data.yaml](arquivos/Resposta-9/pv-data.yaml)</br>
  [pvc-data.yaml](arquivos/Resposta-9/pvc-data.yaml)</br>
  [deploy-meusiteset.yaml](arquivos/Resposta-9/deploy-meusiteset.yaml)</br>

</br>  

10 - Criado um recurso com 2 replicas, chamado `balaclava` com a imagem `redis`, usando as labels nos pods, replicaset e deployment `backend=balaclava` e `minhachave=semvalor` no namespace `backend`.

[deploy-balaclava.yaml](arquivos/Resposta-10/deploy-balaclava.yaml)</br>
[namespace-backend.yaml](arquivos/Resposta-10/namespace-backend.yaml)

</br>

11 - Linhas de comando para listar todos os serviços do cluster do tipo `LoadBalancer` e mostrar o `selectors`.

```bash
  $ kubectl get services --all-namespaces -o wide | grep -i loadbalancer
```

</br>

12 - Linha de comando para criar uma secret chamada `meusegredo` no namespace `segredosdesucesso` com os dados, `segredo=azul` e com o conteúdo do texto abaixo:

```bash
  # cat chave-secreta
     aW5ncmVzcy1uZ2lueCAgIGluZ3Jlc3MtbmdpbngtY29udHJvbGxlciAgICAgICAgICAgICAgICAg
     ICAgICAgICAgICAgTG9hZEJhbGFuY2VyICAgMTAuMjMzLjE3Ljg0ICAgIDE5Mi4xNjguMS4zNSAg
     IDgwOjMxOTE2L1RDUCw0NDM6MzE3OTQvVENQICAgICAyM2ggICBhcHAua3ViZXJuZXRlcy5pby9j
     b21wb25lbnQ9Y29udHJvbGxlcixhcHAua3ViZXJuZXRlcy5pby9pbnN0YW5jZT1pbmdyZXNzLW5n
     aW54LGFwcC5rdWJlcm5ldGVzLmlvL25hbWU9aW5ncmVzcy1uZ
``` 
``` bash
  $ kubectl create secret generic meusegredo -n segredosdesucesso --from-file chave-secreta --from-literal segredo=azul
```

</br>

13 - Linha de comando para criar um configmap chamado `configsite` no namespace `site` contendo a entrada `index.html` com o valor `paulo` .

```bash
  $ kubectl create configmap configsite -n site --from-literal=index.html=paulo
``` 

</br>

14 - Criado recurso chamado `meudeploy`, com a imagem `nginx:latest`, que utiliza a secret criada no exercicio 12 como arquivos no diretorio `/app`.

[meudeploy.yaml](arquivos/Resposta-14/meudeploy.yaml) 

</br>

15 - Criado um recurso chamado `depconfigs`, com a imagem `nginx:latest`, que utilize o configMap criado no exercicio 13, usando o index.html com meu nome como pagina principal do recurso.

[depconfigs.yaml](arquivos/Resposta-15/depconfigs.yaml)

</br>

16 - Criado um novo recurso chamado `meudeploy-2` com a imagem `nginx:1.16`, com a label `chaves=secretas` usando todo conteudo da secret como variavel de ambiente que foin criado no exercicio 12.

[meudeploy-2.yaml](arquivos/Resposta-16/meudeploy-2.yaml)

</br>

17 - linhas de comando que;

    crie um namespace `cabeludo`;
    um deploy chamado `cabelo` usando a imagem `nginx:latest`; 
    uma secret chamada `acesso` com as entradas `username: pavao` e `password: asabranca`;
    exponha variaveis de ambiente chamados USUARIO para username e SENHA para a password.

  ```bash
    $ kubectl create namespace cabeludo

    $ kubectl create deployment cabelo --image=nginx:latest

    $ kubectl create secret generic acesso --from-literal username=pavao --from-literal password=asabranca

    $ USUARIO=`kubectl get secret acesso -o jsonpath='{.data.username}' | base64 -d`
    $ SENHA=`kubectl get secret acesso -o jsonpath='{.data.password}' | base64 -d`
  ```

</br>

18 - Criado um deploy `redis` usando a imagem com o mesmo nome, no namespace `cachehits` e que tenha o ponto de montagem `/data/redis` de um volume chamado `app-cache` que NÂO deverá ser persistente.

[deploy-redis.yaml](arquivos/Resposta-18/deploy-redis.yaml)

</br>

19 - Linha de comando para fazer o scale do deploy chamado `basico` no namespace `azul` para 10 replicas.

```bash
  $ kubectl scale --replicas=10 -n azul deployment basico
``` 

</br>

20 - Linha de comando para criar um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy `site` no namespace `frontend`.

```bash
  $ kubectl autoscale deployment site --min=2 --max=5 --cpu-percent=90 -n frontend
```
</br>

21 - Linha de comando para expor o conteúdo da secret `piadas` no namespace `meussegredos` com a entrada `segredos`.

```bash
  $ kubectl get secret piadas -n meussegredos -o jsonpath='{.data.segredos}' | base64 -d
```

</br>

22 - Adicionado a taint `NoSchedule` node `k8s-worker1` do cluster para não aceitar nenhum novo pod.

```bash
  $ kubectl taint node k8s-worker1 node-role=worker1:NoSchedule
``` 

</br>

23 - Adicionado a taint `NoExecute` node `k8s-worker1` para transferir os pos para outro node.

```bash
  $ kubectl taint node k8s-worker1 node-role=worker1:NoExecute
```

</br>

24 - A maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico é usar o static pod.

```bash
  $ kubectl run static --image=nginx --dry-run=client -o yaml > static-pod.yaml
  
  como root:
  # cp -av /home/paulo/static-pod.yaml /etc/kubernetes/manifests/
  # sudo systemctl restart kubelet
```

</br>

25 - Criado um serviceaccount `userx` no namespace `developer` com permissão total sobre pods, pods/logs e deployments no namespace `developer`.

[service-account-userx.yaml](arquivos/Resposta-25/service-account-userx.yaml)</br>
[cluster-role-userx.yaml](arquivos/Resposta-25/cluster-role-userx.yaml)</br>
[cluster-role-binding-userx.yaml](arquivos/Resposta-25/cluster-role-binding-userx.yaml) </br>

  25.1 - Para validar o acesso ao namespace.

  ```bash
  $ kubectl auth can-i create pods --as system:serviceaccount:developer:userx
  yes

  $ kubectl auth can-i create deploy --as system:serviceaccount:developer:userx
  yes

  $ kubectl auth can-i create services --as system:serviceaccount:developer:userx
  no
  ```

</br>

26 - Gerado key e certificado usando `openssl` para a usuaria `jane` e criado role com apenas permissao de listar pods no namespace `frontend`.

  ```bash
    $ mkdir certs
    $ cd certs
    $ openssl genrsa -out jane.key 2048
    $ openssl req -new -key jane.key -out jane.csr
    $ openssl req -new -key jane.key -out jane.csr -subj "/CN=jane/O=frontend"
  ``` 
  26.1 - Copiar a saída do comando abaixo e colar no `request:` do arquivo certificate-signing-request.yaml
  ``` bash 
    $ cat jane.csr | base64 | tr -d "\n"
  ```
  [certificate-signing-request.yaml](arquivos/Resposta-26/certificate-signing-request.yaml)

  ```bash
    $ kubectl apply -f certificate-signing-request.yaml
    $ kubectl get csr
    $ kubectl certificate approve jane
    $ kubectl get csr jane -o jsonpath='{.status.certificate}'| base64 -d > jane.crt
    $ kubectl create namespace frontend
    $ kubectl create role jane --verb=list --resource=pods -n frontend
    kubectl create rolebinding jane-binding --role=developer --user=myuser
    $ kubectl config set-credentials jane --client-key=jane.key --client-certificate=jane.crt --embed-certs=true
    $ kubectl config set-context jane --cluster=kubernetes --user=jane
  ```
  26.2 - Comandos para testar:
  ```bash
    $ kubectl config use-context jane

    $ kubectl get ns 
    Error from server (Forbidden): namespaces is forbidden: User "jane" cannot list resource "namespaces" in API group "" at the cluster scope

    $ kubectl run teste --image=nginx  -n frontend
    Error from server (Forbidden): pods is forbidden: User "jane" cannot create resource "pods" in API group "" in the namespace "frontend"

    $ kubectl get pods -n frontend
    No resources found in frontend namespace.
  ```

27 - Comando para exibir o status do scheduler, controller-manager e etcd ao mesmo tempo: 

```
  $ kubectl get componentstatuses
```
