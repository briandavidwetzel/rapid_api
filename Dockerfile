FROM ruby:2.3.1

########################################
ENV APP_HOME /myapp
ENV BUNDLE_PATH /cache
########################################

RUN apt-get update -qq && apt-get install -y build-essential

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev


RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
