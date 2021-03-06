#!/usr/bin/env sh
PYTHON_VER=3.8.1
NODE_VER=12.16.0
NPM_VER=6.13.7
YARN_VER=1.22.0
PUPP_VER=2.1.1
CHROME_VER=81.0.4044.17
DOCKER_VER=19.03.2
HEROKU_VER=7.30.1

PROJECT_NAME=pynode
FULL_PROJECT_NAME=${PROJECT_NAME}:python${PYTHON_VER}-node${NODE_VER}-npm${NPM_VER}
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
bold=`tput bold`
reset=`tput sgr0`

LINE_LEN=80

###############################################################################
# HELPER FUNCTIONS

# Check current build status and exit if in failure state
check_status() {
  if [ $? != 0 ];
    then
    echo "${bold}${red}Build failed at" $1 "${reset}"
    exit 1    
  fi
  echo "${bold}${cyan}""$(nchars '=' $LINE_LEN)"
}

# Output repeated character where $1 is char, and $2 is count
nchars() {
  OUTPUT=''
  for i in $(seq 0 $2)
  do
    OUTPUT=$OUTPUT$1
  done
  echo $OUTPUT
}

# Show title surrounded by equal signs
title() {
  TOTAL_LEN=$LINE_LEN
  STR_LEN=${#1}
  NUM_CHARS=$((($TOTAL_LEN-$STR_LEN-2)/2))
  echo "${cyan}${bold}"$(nchars "=" $NUM_CHARS) $1 $(nchars "=" $NUM_CHARS)"${reset}"
}
###############################################################################

# Check DOCKER_HUB_USERNAME is set as an environment variable
if [ -z $DOCKER_HUB_USERNAME ];
then
  echo "${bold}${red}DOCKER_HUB_USERNAME environment variable not set"
fi

# Check there is something to build
if [ -z "${1}" ];
  then
  echo "Build failed - select a build:"
  echo "   ./build.sh ${bold}${cyan}base${reset}"
  exit 1
fi

updateDockerFile() {
  cp $1/Dockerfile DockerfileTemp
  sed "s/FROM .*/FROM ${DOCKER_HUB_USERNAME}\/${FULL_PROJECT_NAME}/" \
      < DockerfileTemp > Dockerfile
  rm DockerfileTemp
}


# Build base image
if [ $1 = "base" ];
  then
  title "Building Base Image"
  cp base/Dockerfile DockerfileTemp
  sed "s/FROM python:.*/FROM python:${PYTHON_VER}-slim/" \
      < DockerfileTemp | \
      sed "s/ENV NODE_VERSION.*/ENV NODE_VERSION ${NODE_VER}/" | \
      sed "s/ENV YARN_VERSION.*/ENV YARN_VERSION ${YARN_VER}/" | \
      sed "s/RUN npm install -global npm@.*/RUN npm install -global npm@${NPM_VER}/" > Dockerfile
  rm DockerfileTemp
  docker build -t $DOCKER_HUB_USERNAME/$FULL_PROJECT_NAME .
  docker build -t $DOCKER_HUB_USERNAME/$PROJECT_NAME:latest .
  check_status "Building Base Image"
  rm Dockerfile
  if [ $2 ];
  then
    if [ $2 = "deploy" ];
    then
      title "Pushing Base Image"
      docker push $DOCKER_HUB_USERNAME/$FULL_PROJECT_NAME
    fi
  fi
  exit 0
fi

# Build base image
if [ $1 = "dh" ];
  then
  title "Building Docker/Heroku Image"
  updateDockerFile "docker-heroku"
  PROJECT_NAME=$FULL_PROJECT_NAME-docker$DOCKER_VER-heroku$HEROKU_VER
  if [ $2 = "test" ];
  then
    PROJECT_NAME=dh-test
  fi
  docker build -t $DOCKER_HUB_USERNAME/$PROJECT_NAME .
  check_status "Building Docker Heroku Image"
  rm Dockerfile
  if [ $2 ];
  then
    if [ $2 = "deploy" ];
    then
      title "Pushing Docker-Heroku Image"
      docker push $DOCKER_HUB_USERNAME/$PROJECT_NAME
    fi
  fi
  exit 0
fi

# Build base image
if [ $1 = "pupp" ];
  then
  title "Building Docker/Heroku Image"
  updateDockerFile "puppeteer"
  PROJECT_NAME=$FULL_PROJECT_NAME-puppeteer${PUPP_VER}-chrome${CHROME_VER}
  if [ $2 = "test" ];
  then
    PROJECT_NAME=pupp-test
  fi
  docker build -t $DOCKER_HUB_USERNAME/$PROJECT_NAME .
  check_status "Building Docker Heroku Image"
  rm Dockerfile
  if [ $2 ];
  then
    if [ $2 = "deploy" ];
    then
      title "Pushing Puppeteer Image"
      docker push $DOCKER_HUB_USERNAME/$PROJECT_NAME
    fi
  fi
  exit 0
fi

# If got to here, the image wasn't dev or base and error should be thrown
echo "Image ${bold}${cyan}$1${reset} doesn't exist"
exit 1
