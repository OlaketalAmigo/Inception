COMPOSE_FILE = ./docker-compose.yml

all: up

up:
	docker compose -f $(COMPOSE_FILE) up --build --no-cache -d

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes

fclean: clean
	docker system prune -f

re: fclean all

.PHONY: all up down bonus clean fclean re
