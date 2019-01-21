# pynode
Container with Python, Node and NPM.

node:10.15.0-slim dockerfile based on python image rather than debian.

# To create

#### First setup the DOCKER_HUB_USERNAME
`export DOCKER_HUB_USERNAME=[enter_user_name_here]`

### Update version numbers
In build.sh file, update PYTHON_VER, NODE_VER and NPM_VER to be the wanted versions.

#### Build
`./build.sh base`

This will build a local image called pynode:python3.7.2-node10.15.0-npm6.6.0 assuming python, node and npm versions were 3.7.2, 10.15.0 and 6.6.0 in build.sh.

Also, a pynode:latest container will be created.

#### To run container to test
`docker run -it pynode:latest bash`

#### To build and push to docker hub:
./build.sh base deploy

Only the explicit version container will be pushed up.
