FROM airladon/pynode:python3.7.4-node12.10.0-npm6.11.3

# Docker
RUN apt-get update && \
	   apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
 		 curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	 	 add-apt-repository \
   	 "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   	 $(lsb_release -cs) \
   	 stable" && \
 		 apt-get update && \
 		 apt-get -y install docker-ce

# Heroku
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
