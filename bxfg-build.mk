ALL = clone/bxfg setup/bxfg2 setup/bigboss2front setup/bigboss2ib setup/bigboss2member setup/bxfg2front setup/bxfg2docker run/bxfg

all: $(ALL)
.PHONY: $(ALL)

clone/bxfg:
	sudo rm -rf bxfg2/ && \
	mkdir bxfg2 && \
	cd bxfg2 && \
	git clone git@bitbucket.org:glbbestinc/bxfg2docker.git && \
	git clone git@bitbucket.org:glbbestinc/bxfg2.git && \
	git clone git@bitbucket.org:glbbestinc/bigboss2front.git && \
	git clone git@bitbucket.org:glbbestinc/bigboss2ib.git && \
	git clone git@bitbucket.org:glbbestinc/bxfg2front.git && \
	git clone git@bitbucket.org:glbbestinc/bigboss2member.git
setup/bxfg2:
	cd ~/bxfg2/bxfg2 && \
	cp -p .env.example .env && \
	make composer args="install" && \
	make php args="artisan key:generate" && \
	make php args="artisan --version"
setup/bigboss2front:
	cd ~/bxfg2/bigboss2front && \
	cp -p .env.example .env && \
	make composer args="install" && \
	make npm args="install" && \
	make php args="artisan key:generate" && \
	make php args="artisan --version" && \
	make node args="-v" && \
	make npm args="-v"
setup/bigboss2ib:
	cd ~/bxfg2/bigboss2ib && \
	cp -p .env.example .env && \
	make composer args="install" && \
	make npm args="install" && \
	make php args="artisan key:generate" && \
	make php args="artisan --version" && \
	make node args="-v" && \
	make npm args="-v"
setup/bigboss2member:
	cd ~/bxfg2/bigboss2member && \
	cp -p .env.example .env && \
	make composer args="install" && \
	make php args="artisan key:generate"
setup/bxfg2front:
	cd ~/bxfg2/bxfg2front && \
	cp -p .env.example .env && \
	make composer args="install" && \
	make php args="artisan key:generate"
setup/bxfg2docker:
	cd ~/bxfg2/bxfg2docker/docker && \
	docker compose build -d
run/bxfg:
	cd ~/bxfg2/bxfg2docker/docker && \
	docker compose up -d
down/bxfg:
	cd ~/bxfg2/bxfg2docker/docker && \
	docker compose down
rebuild/bxfg:
	cd ~/bxfg2/bxfg2docker/docker && \
	docker compose down && \
	docker compose build --no-cache && \
	docker compose up -d