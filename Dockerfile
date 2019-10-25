FROM ubuntu:18.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y php php-dom

# uncomment below if you want to access http://127.0.0.1:8000
#RUN apt-get install -y wget
#RUN wget https://get.symfony.com/cli/installer -O - | bash
