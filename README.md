## Description

The present project consist in the communication between 3 different services, allowing us to detect if a driver have become a zombie or not. Zombieness is detected based on the gps locations of the drivers, which we receive each few seconds.

If the distance travelled is lower than some threshold in some specific amount of time the driver is considered a zombie.

This project consist in the following three services:

To setup the whole project just run the following command in the root directory and it will install all dependencies:

```
make setup
```

## Gateway

This service is the only service exposed to the outside, receiving http requests and redirecting them through different protocols.

Those redirections are specified in the file config.yaml, at the moment only HTTP (GET, POST, PUT, PATCH verbs) and NSQ are available.

In the case of http, the raw response is returned to the caller.

## Driver Location

This service is the responsible for handling the locations, in two different ways:

* Receives a location and stores it in redis
* Searches locations given some time threshold, later used to detec is a driver is a zombie or not

## Zombie Driver

This service queries `driver-location` service and calculates the travelled distance of the driver, if it's lower than some amount it might be a zombie.

The distance threshold and the time range used to query the locations is configurable throught environment variables, see configuration for module `ZombieDriver.StatusChecker` in the file `zombie_driver/config/config.exs`