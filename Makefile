# Makefile for hammer_load_test


default: run


docker-compose.yml:
	erb docker-compose.yml.erb > docker-compose.yml


run: docker-compose.yml
	docker-compose up


load-test:
	artillery run load-test.yml


PHONY: default run load-test
