# free5gc-Docker

## Dependencies

* [Docker](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)


## Base Image
Each box of project is based on a compiled free5gc image. To build this image use the follow command:
``sudo docker build -t free5gc-base .``

## Running
To run all boxes and Web interface use the follow command:
``sudo docker-compose up -d``

The web app is available into http://localhost:3000.

User: admin
Password: 1423
