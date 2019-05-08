# pynode
Container with Python, Node and NPM.

node:10.15.0-slim dockerfile based on python image rather than debian.

# To create
#### Images
There are three images:
* Base - the base python, node, npm image
* Docker-heroku - Base image with docker and heroku installed on it
* Puppeteer - Base image with puppeteer installed on it

If updating python, node and/or npm and you want to update all images then:

* In build.sh file, update PYTHON_VER, NODE_VER, NPM_VER and YARN_VER to be the wanted versions.
* `export DOCKER_HUB_USERNAME=[enter_user_name_here]`
* Login to docker (if not already logged in) if you want to deploy: `docker login`
* build each image:
```
./build.sh base
./build.sh dh
./build.sh pupp
```
* Test locally - for example to run the base image use:
```
docker run -it ${DOCKER_HUB_USERNAME}/pynode:latest bash
```
* If local tests out ok, then deploy
```
docker login
./build.sh base deploy
./build.sh dh deploy
./build.sh pupp deploy
```

>> Note: there might be an error in updating puppeteer where the folder linux-650583 can't be found. In that case,
* remove all puppeteer/Dockerfile lines from line 39 to the end
* ./build pupp
* docker run -it <image name> bash
* ls /node_modules/puppeteer/.local-chromium/
* Find new number and update docker file
* ./build pupp


#### Output
This will build a local image called pynode:python3.7.2-node10.15.0-npm6.6.0 assuming python, node and npm versions were 3.7.2, 10.15.0 and 6.6.0 in build.sh.

Also, a pynode:latest container will be created.


# Other useful docker commands:

##### See main images:
```
docker images
```

##### See all images:
```
docker images -a
```

##### See running containers:
```
docker ps
```

##### See all containers:
```
docker ps -a
```

##### Remove container
```
docker rm CONTAINTER_ID
docker rm CONTAINTER_NAME
```

##### Remove all exited containers:
```
docker rm `docker ps -aq --no-trunc --filter "status=exited"`
```

##### Remove all unused images:
```
docker system prune -a
```

##### Remove all untagged images:
```
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```