ARG JDK_IMAGE
FROM $JDK_IMAGE

RUN \
    apt-get --quiet update --yes && \
    apt-get --quiet install --yes git wget tar unzip cmake lib32stdc++6 lib32z1 ninja-build python3
RUN echo "Installing sentry client"
RUN curl -sL https://sentry.io/get-cli/ | SENTRY_CLI_VERSION="2.36.3" sh
