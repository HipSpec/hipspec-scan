# Container image that runs your code
FROM ruby:2.7-slim

RUN apt-get install -y --no-install-recommends git

RUN sudo gem install git
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY repo-scan.rb /repo-scan.rb
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
