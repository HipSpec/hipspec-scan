# Container image that runs your code
# HIPSPEC-SAMPLE-3

FROM ruby:2.7-slim

RUN apt-get update 
RUN apt-get install -y --no-install-recommends git

RUN gem install git
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY repo-scan.rb /repo-scan.rb
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
