PROJECT_NAME=learncircle
DOCKER_COMPOSE=docker compose
OVERRIDE=-f infra/docker-compose.yml -f infra/docker-compose.dev.yml

# ---- COMANDOS ----

## Sobe containers em produção
prod:
	$(DOCKER_COMPOSE) -f infra/docker-compose.yml up -d --build

## Sobe containers em desenvolvimento
dev:
	$(DOCKER_COMPOSE) $(OVERRIDE) up -d --build

## Para containers (funciona tanto dev quanto prod)
down:
	$(DOCKER_COMPOSE) $(OVERRIDE) down || $(DOCKER_COMPOSE) -f infra/docker-compose.yml down

## Mostra logs (em dev por padrão)
logs:
	$(DOCKER_COMPOSE) $(OVERRIDE) logs -f

## Executa shell no app
shell-node:
	$(DOCKER_COMPOSE) $(OVERRIDE) exec app sh

## Executa shell no web
shell-web:
	$(DOCKER_COMPOSE) $(OVERRIDE) exec web sh

## Reconstrói containers sem cache
rebuild:
	$(DOCKER_COMPOSE) $(OVERRIDE) build --no-cache	

## Sobe containers em desenvolvimento sem buildar novamente
dev-no-build:
	$(DOCKER_COMPOSE) $(OVERRIDE) up -d

## Sobe containers em produção sem buildar novamente
prod-no-build:
	$(DOCKER_COMPOSE) -f infra/docker-compose.yml up -d