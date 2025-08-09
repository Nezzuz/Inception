.PHONY: up rebuild

up:
	@docker compose -f ./srcs/docker-compose.yml up
rebuild:
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@docker compose -f ./srcs/docker-compose.yml up
