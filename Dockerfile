FROM ubuntu:precise
FROM python:2.7

MAINTAINER JOOEUN

RUN apt-get update
RUN apt-get install -y build-essential git
RUN apt-get install -y python python-dev python-setuptools
RUN apt-get install -y nginx supervisor
RUN easy_install pip

RUN pip install uwsgi

RUN apt-get install -y python-software-properties software-properties-common
RUN apt-get update
RUN add-apt-repository -y ppa:nginx/stable

ADD . /code/

ADD requirements.txt /code/

RUN pip install -r /code/requirements.txt

RUN chown -R www-data:www-data /code

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /code/supervisor-app.conf /etc/supervisor/conf.d/

WORKDIR /code

EXPOSE 80 22
CMD ["supervisord", "-n"]