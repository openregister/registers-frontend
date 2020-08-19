build:
	docker-compose build

populate:
	docker-compose run --rm web rails db:setup
	docker-compose run --rm web rake registers_frontend:populate_db:fetch_now

serve: build
	docker-compose up -d

stop:
	docker-compose down

# starts the web process interactively to attach to debugger breakpoints
istart: build
	docker-compose run --publish 3000:3000 web

logs:
	docker-compose logs --follow web

shell:
	docker-compose exec web bash
