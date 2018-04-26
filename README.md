# Hammer Load Test

Sets up a cluster of phoenix servers, using Hammer and Redis for rate-limiting,
and subjects them to a load test.

## Dependencies

- docker
- docker-compose
- [artillery](https://artillery.io)
- ruby (for the `erb` tool, should be present on most machines)
- make

Tested on:
```shell
$ docker --version
Docker version 18.03.0-ce, build 0520e24

$ docker-compose --version
docker-compose version 1.20.1, build 5d8c71b

```


## Setup

```shell
$ make run -B
```


## Perform the load test

```shell
$ make load-test
```

## Expectations

We should ideally see no 500 responses from the test. If we have any,
they're probably from the Hammer-Redis race-condition described here:
https://github.com/ExHammer/hammer-backend-redis/issues/11
