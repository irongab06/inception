# Nom du fichier de configuration docker-compose
COMPOSE_FILE = docker-compose.yml

# Nom du projet (peut être personnalisé)
PROJECT_NAME = inception

# Commandes de base
DOCKER_COMPOSE = docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE)

# Règles principales
.PHONY: all build up start stop down clean logs ps

# Build et démarre les services
all: build up

# Build les images
build:
	$(DOCKER_COMPOSE) build

# Démarre les containers en mode détaché (-d)
up:
	$(DOCKER_COMPOSE) up -d

# Démarre sans reconstruire
start:
	$(DOCKER_COMPOSE) start

# Stoppe les services sans les supprimer
stop:
	$(DOCKER_COMPOSE) stop

# Supprime les containers mais garde les volumes
 down:
	$(DOCKER_COMPOSE) down

# Supprime tout : containers, volumes et images non utilisées
clean:
	$(DOCKER_COMPOSE) down -v
	docker system prune -af --volumes
	docker network prune -f
	docker volume prune -f

# Affiche les logs des containers
logs:
	$(DOCKER_COMPOSE) logs -f

# Liste les containers en cours d'exécution
ps:
	$(DOCKER_COMPOSE) ps
