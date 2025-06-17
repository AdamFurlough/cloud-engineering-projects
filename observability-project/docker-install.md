# Observability Project - Step 2 - Install Docker (if not already installed via user data)

If you deployed a new RHEL instance using the cloudformation in step 1 then you can skip this step.  If you are configuring an exiting RHEL EC2 then you will need to install docker on it before setting up the logging agent containers.

## Install docker

```
sudo yum -y update
sudo yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce --nobest -y
sudo systemctl start docker
sudo systemctl enable docker
```

## if running as non-root

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

## optional tests

```
docker --version
docker run hello-world
```

## basics

- `docker images` - show all downloaded images
- `docker ps` - show running containers
- `docker ps -a` - show all containers (even stopped)do

## run

- `docker run myimage` - run in foreground
- `docker run -d myimage` - run in background, detach

## open bash cli inside container

- `docker exec -it <container_name> bash`
- `docker exec -it busy_curie bash` - example

## see logs

- `docker compose logs -f`
