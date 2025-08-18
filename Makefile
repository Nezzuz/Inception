.PHONY: up down rebuild addHost

up:
	@docker compose -f ./srcs/docker-compose.yml up
down:
	@docker compose -f ./srcs/docker-compose.yml down -v
rebuild:
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@docker compose -f ./srcs/docker-compose.yml up
addHost:
	@echo "127.0.0.1 jleon-la.42.fr" >> /etc/hosts && echo "DONE"
