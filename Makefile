srv-start:
	sudo systemctl stop docker
	sudo systemctl start docker
	docker-compose --env-file ./site/.env.local up --detach
	sleep 10
	make migrate-install
	sleep 5
	make migrate-fresh
	sudo sysctl -w fs.inotify.max_user_watches=100000
	cd site; npm rebuild node-sass; npx webpack --watch

srv-stop:
	docker-compose --env-file ./site/.env.local down

srv-build:
	docker-compose --env-file ./site/.env.local build

composer:
	docker exec barbershop_app_1 composer dump-autoload && composer install

bash:
	docker exec -it barbershop_app_1 bash

# ==========================
# Laravel Migrations
# ==========================

migrate:
	docker exec -it barbershop_app_1 php artisan migrate

migrate-fresh:
	docker exec -it barbershop_app_1 php artisan migrate:fresh --seed

migrate-rollback:
	docker exec -it barbershop_app_1 php artisan migrate:rollback

migrate-install:
	docker exec -it barbershop_app_1 php artisan migrate:install

migrate-create:
	docker exec -it barbershop_app_1 php artisan make:migration ${name}

# ==========================
# Laravel Models
# ==========================

model-create:
	docker exec -it barbershop_app_1 php artisan make:model ${name}

# ==========================
# Laravel Seeders
# ==========================

seeder-create:
	docker exec -it barbershop_app_1 php artisan make:seeder ${name}