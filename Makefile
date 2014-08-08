NAME = bkreider/docker-sentry
VERSION = 0.1.0

# Set the SENTR_CONFIG_URL  env var to your sentry.conf.py file.
#SENTRY_CONFIG_URL ?= https://gist.github.com/pblittle/8778567/raw/logstash.conf

DIR := ${CURDIR}

clean:
	rm -f .build_test

build:
	docker build --rm -t $(NAME):$(VERSION) .

run:
	docker run -d \
		-p 9000:9000 \
		--name sentry \
		$(NAME):$(VERSION)

tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release:
	docker push $(NAME)

shell:
	docker run -t -i --rm $(NAME):$(VERSION) bash

build_test:
	docker build --rm -t logstash_test test
	touch .build_test

test: run 
	# Host shared volume isn't working properly??
	# Embed the test script in the dockerfile
	docker run -i --link logstash:logstash -v $(DIR)/test:/test -t logstash_test /bin/bash

clean_test:
	docker kill logstash
	docker rm logstash
