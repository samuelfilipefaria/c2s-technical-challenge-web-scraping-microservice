#  Microserviço de web scraping

# Como executar o projeto

## Requisitos para rodar

- Docker Engine devidamente instalado
- Docker Compose devidamente instalado
- Portas `6000`, `10000`, `11000` e `7000` da máquina disponíveis

> Sugestão: utilizar [Docker Desktop](https://www.docker.com/products/docker-desktop/), pois traz os requisitos acima além de uma interface gráfica que simplifica o gerenciamento de múltiplos containers.

## Como rodar a primeira vez

Navegue até o diretório onde se encontra o código adquirido através deste repositório e execute o seguinte comando:

```
docker compose up
```

Este comando irá criar a imagem baseado no código fonte e com essa imagem irá criar e iniciar o container docker. Além disso também criará o banco de dados (incluindo o de testes).

Da próxima vez que for rodar basta iniciar o container, não precisará o construir (a menos que tenha acontecido alguma mudança em relação as dependências no projeto, mas isto é apenas para fins de desenvolvimento).

## Para executar a suite de testes basta rodar o seguinte comando no diretório raiz do projeto

```
rspec spec/
```

# Documentação da API

| Verb | Route                   | Parameters                 |
|------|-------------------------|----------------------------|
| post | web_scraping/web_motors | token,web_scraping_task_id |
