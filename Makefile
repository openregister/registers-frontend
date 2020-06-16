build:
	docker-compose build

populate:
	docker-compose run --rm web rails db:setup
	docker-compose run --rm web rake registers_frontend:populate_db:fetch_now

serve: build
	docker-compose up -d

shell:
	docker-compose exec web bash
