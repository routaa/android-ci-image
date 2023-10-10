ARG JDK_IMAGE
FROM $JDK_IMAGE

RUN \
    apt-get --quiet update --yes && \
    apt-get --quiet install --yes git wget tar unzip cmake lib32stdc++6 lib32z1
