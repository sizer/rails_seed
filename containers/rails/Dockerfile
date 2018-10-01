FROM ruby:2.5.1

#############
##   ENV   ##
#############
ENV SRC_DIR /usr/local/src

# Root of rails project
ENV APP_HOME /var/www

# Install global gem in external strage
ENV BUNDLE_PATH /bundle/ruby/2.5.1
ENV BUNDLE_TIMEOUT 30

# Node version$
ENV NODE_VERSION 8.12.0
ENV NODE_PACKAGE node-v$NODE_VERSION-linux-x64

# Enable Japanese input
ENV LANG C.UTF-8

#############
## COMMAND ##
#############
# Essential
RUN apt-get update -qq && \
    apt-get install -y build-essential zip vim wget apt-transport-https

# For NodeJS
RUN cd $SRC_PATH && \
    wget https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.xz && \
    xz -dv $NODE_PACKAGE.tar.xz && \
    tar -xvf $NODE_PACKAGE.tar -C /usr/local --strip-components 1 && \
    rm $NODE_PACKAGE.tar

# For Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# For mysql
RUN apt-get install -y mysql-client

# For nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# Remove cache
RUN rm -rf /var/lib/apt/lists/*

# Change timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Root directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#############
##   PORT  ##
#############
EXPOSE 3000

#############
##  SERVER ##
#############
# Always delete pid
CMD bash -c "rm -f tmp/pids/server.pid && bin/rails s -b 0.0.0.0 -P tmp/pids/server.pid"
