# pynode
Container with Python, Node and NPM.

node:10.15.0-slim dockerfile based on python image rather than debian.

# To create

#### First setup the DOCKER_HUB_USERNAME
`export DOCKER_HUB_USERNAME=[enter_user_name_here]`

#### Build
`./build.sh base`

#### To run container to test
`docker run -it pynode:latest bash`

#### To build and push to docker hub:
./build.sh base deploy

