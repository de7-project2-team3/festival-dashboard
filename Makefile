.PHONY: init

init:
	uv venv && uv sync

superset-init:
	cd docker/superset && docker compose up -d && docker exec -it superset superset fab create-admin --username admin --firstname Admin --lastname User --email admin@example.com --password admin
superset-up:
	cd docker/superset && docker compose up -d 
superset-down:
	cd docker/superset && docker compose down
superset-reset:
	cd docker/superset && docker compose down -v --remove-orphans