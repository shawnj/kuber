FROM library/node:10.8.0-alpine

# Increment app version if changing this file
ARG APP_VERSION=1.0.2

RUN apk add --update zip

ENTRYPOINT ["bash"]