ALL = clean/build clone/repo start/containers setup/focrex-admin setup/focrex-webapp setup/focrex-member run/all run/webapp run/member run/admin logs/clear

build_local: $(ALL)
.PHONY: $(ALL) bash/focrex-member artisan/focrex-webapp cache/clear/focrex-webapp

focrex/local/run:
	cd focrex && \
	docker-compose -f docker-compose.yml -f docker-compose.backend.yml down && \
	docker-compose -f docker-compose.yml -f docker-compose.backend.yml up -d && \
	docker-compose exec -d focrex-member yarn build:dev && \
	docker-compose exec -d focrex-member yarn serve:dev && \
	docker exec -d focrex-webapp yarn dev
focrex/local/down:
	cd focrex && \
	docker-compose -f docker-compose.yml -f docker-compose.backend.yml down
clean/build:
	sudo rm -rf focrex && \
	git clone git@bitbucket.org:glbbestinc/focrex-dev-docker.git focrex
clone/repo:
	cd focrex && \
	git clone git@bitbucket.org:glbbestinc/focrex-member.git focrex-member && \
	git clone git@bitbucket.org:glbbestinc/focrex-admin.git focrex-admin && \
	git clone git@bitbucket.org:glbbestinc/focrex-webapp.git focrex-webapp && \
	git clone git@bitbucket.org:glbbestinc/focrextrade.git focrex-trade && \
	git clone git@bitbucket.org:glbbestinc/focrex-settlement.git focrex-settlement && \
	git clone git@bitbucket.org:glbbestinc/focrex-pusher.git focrex-pusher && \
	git clone git@bitbucket.org:glbbestinc/focrex-chart.git focrex-chart && \
	git clone git@bitbucket.org:glbbestinc/focrex-bot.git focrex-bot && \
	cd focrex-member/public && \
	git clone git@bitbucket.org:glbbestinc/tradingview_charting_library.git && \
	cd ~/focrex && \
	sed -i 's/COMPOSE_PROJECT_NAME=focrex/COMPOSE_PROJECT_NAME=focrex-local-env-linux/g' .env.example && \
	cp ~/focrex/.env.example ~/focrex/.env && \
	sed -i 's/php:8.1-fpm-alpine/php:8.0.2-fpm-alpine/g' ~/focrex/docker/dev/cryptos-staking/Dockerfile ~/focrex/docker/dev/focrex-bxfg/Dockerfile ~/focrex/docker/dev/focrex-admin/Dockerfile ~/focrex/docker/dev/focrex-webapp/Dockerfile && \
	sed -i 's/DB_CONNECTION=sqlite/#DB_CONNECTION=sqlite/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_CONNECTION=mysql/DB_CONNECTION=mysql/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_HOST=db/DB_HOST=db/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_PORT=3306/DB_PORT=3306/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_DATABASE=focrex/DB_DATABASE=focrex/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_USERNAME=develop/DB_USERNAME=develop/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_PASSWORD=secret/DB_PASSWORD=secret/g' focrex-admin/laravel/.env.example && \
	sed -i 's/#DB_READ_HOST=db/DB_READ_HOST=db/g' focrex-admin/laravel/.env.example && \
	cd ../ && \
	sudo chmod 777 -R ~/focrex/ && \
	sudo rm -rf ~/focrex/focrex-member/.env/ && \
	sed -i 's/https\:\/\/localhost\:8080\/api\/v1\/xxx/http\:\/\/localhost\:8082\/api\/v1/g' ~/focrex/focrex-member/.env.sample && \
	sed -i "6iVUE_APP_FOCREX_FRONT_URL='http://localhost:8080'" ~/focrex/focrex-member/.env.sample
setup/cryptos-staking:
	cd ~/focrex/ && \
	git clone git@bitbucket.org:glbbestinc/cryptos-staking.git cryptos-staking && \
	docker-compose exec cryptos-staking cp .env.example .env && \
	docker exec cryptos-staking apk add composer && \
	docker exec cryptos-staking apk add yarn && \
	docker exec cryptos-staking apk add npm && \
	docker-compose exec cryptos-staking composer install && \
	docker-compose exec cryptos-staking yarn && \
	docker-compose exec cryptos-staking php artisan key:generate && \
	docker-compose exec cryptos-staking php artisan migrate:refresh --seed
setup/focrex-admin:
	docker exec focrex-admin cp .env.example .env && \
	docker exec focrex-admin apk add composer && \
	docker exec focrex-admin apk add yarn && \
	docker exec focrex-admin apk add npm && \
	docker exec focrex-admin composer install && \
	docker exec focrex-admin yarn && \
	docker exec focrex-admin script/empty_sqlitedb.sh && \
	docker exec focrex-admin php artisan key:generate && \
	docker exec focrex-admin php artisan migrate:refresh --seed
setup/focrex-webapp:
	docker exec focrex-webapp cp .env.example .env && \
	docker exec focrex-webapp apk add composer && \
	docker exec focrex-webapp apk add yarn && \
	docker exec focrex-webapp apk add npm && \
	docker exec focrex-webapp composer install && \
	docker exec focrex-webapp yarn && \
	docker exec focrex-webapp php artisan key:generate && \
	docker exec focrex-webapp php artisan migrate:refresh --seed
setup/focrex-member:
	docker exec focrex-member cp .env.sample .env && \
	docker exec focrex-member yarn
start/trade/usdt:
	docker exec -d focrex-trade go run cmd/daemon/main.go -s btcusdt
	docker exec -d focrex-trade go run cmd/daemon/main.go -s ethusdt
	docker exec -d focrex-trade go run cmd/daemon/main.go -s btcjpy
start/settlement:
	docker exec -d focrex-settlement go run cmd/daemon/main.go
start/pusher:
	docker exec -d focrex-pusher go run cmd/main.go
start/containers:
	docker-compose -f focrex/docker-compose.yml -f focrex/docker-compose.backend.yml down
	docker-compose -f focrex/docker-compose.yml -f focrex/docker-compose.backend.yml up -d
run/member:
	docker exec -d focrex-member yarn build:dev
	docker exec -d focrex-member yarn serve:dev
run/webapp:
	docker exec -d focrex-webapp yarn dev
run/admin:
	docker exec focrex-admin yarn dev
	docker exec -d focrex-admin php artisan serve
run/all:
	docker-compose -f focrex/docker-compose.yml -f focrex/docker-compose.backend.yml stop
	cd ~/focrex/ && \
	docker-compose up --build -d
run/staking:
	docker exec -d cryptos-staking php artisan serve
down/containers:
	docker-compose -f focrex/docker-compose.yml -f focrex/docker-compose.backend.yml down
modernize/trade:
	cd ~/focrex/focrex-trade && \
	git fetch && \
	git checkout development && \
	git pull
modernize/settlement:
	cd ~/focrex/focrex-settlement && \
	git fetch && \
	git checkout development && \
	git pull
bash/member:
	docker exec -it focrex-member bash
bash/webapp:
	docker exec -it focrex-webapp bash
bash/admin:
	docker exec -it focrex-admin bash
cache/webapp:
	docker exec focrex-webapp php artisan cache:clear
logs/clear:
	docker exec focrex-webapp rm storage/logs/laravel.log
	docker exec focrex-admin rm storage/logs/laravel.log
