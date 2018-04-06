Training: computer-database
===========================

# 1. Continuous Integration / Continuous Delivery (6 days)
We want to setup a continuous integration/delivery  system for our webapp with [Jenkins](https://jenkins-ci.org/) and [Docker](https://www.docker.com). Each time we push on master we want Jenkins to retrieve the changes, compile, test on a specific environment, build and push the new image to a registry, then automatically deploy the new image on the Cloud.

## 1.1 Jenkins & Docker

Create two Docker images : 
- One to compile, test and package your webapp
- One for the MySQL containing you test data

The both will need to communicate so the unit tests can access to the tests data

Install and configure a Jenkins and create a job that starts the build process everytime a push is performed on master.

## 1.2 Your app in docker

Create two Docker images : 
- one for your webapp
- one for your MySQL in production mode 

Use DockerHub and configure your Jenkins so it pushes your images on DockerHub

## 1.3 Continuous Delivery
Create four Docker images: one for jenkins, one for compilation and tests, one for production (tomcat) and one for the mysql. Push them to DockerHub.

- Connect with your login to [Docker Cloud](https://cloud.docker.com/) 

- Create a [free account](https://aws.amazon.com/fr/free/) on Amazon Web Services.

- [Link](https://docs.docker.com/docker-cloud/getting-started/link-aws/) your Amazon Web Services account to deploy node clusters and nodes using Docker Cloud’s dashboard. Be careful when choosing the type of node on Docker Cloud, select 't2.micro' under the conditions of free AWS account.

- Observe the diagram below to properly configure the architecture of Docker containers to set up the continuous delivery:
![image](http://s32.postimg.org/iio0ls66t/Continuous_delivery.png)

- Below the activity diagram to figure out all the process:
![image](http://s32.postimg.org/ijyeykoyd/CDProcess_Diagram.png)

# HOW-TOs

## new-manager.sh
Main use :
./new-manager.sh --start-all : launches the 3 required containers.
./new-manager.sh --kill-all : closes the 3 containers and removes them. also removes the network.

## Jenkins access
Before launching the job, in a terminal, write the following:
	docker exec -it jnkns-cdb bash
	sudo docker login
and log in with credentials.
Go to http://172.18.0.4:8080/job/computer-database/ to launch the job build manually.
