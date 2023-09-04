FROM debian:bullseye-20230814-slim
ENV ANDROID_HOME="/android-home"
ARG \
    ANDROID_COMPILE_SDK="33" \
    ANDROID_BUILD_TOOLS="33.0.2" \
    ANDROID_SDK_TOOLS="6514223"
RUN \
    apt-get --quiet update --yes && \
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 && \
    install -d $ANDROID_HOME && \
    wget --output-document=$ANDROID_HOME/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip && \
    pushd $ANDROID_HOME && \
    unzip -d cmdline-tools cmdline-tools.zip && \
    popd && \
    export PATH=$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin/ && \
    sdkmanager --version && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses || true
RUN \
    sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}" && \
    sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" && \
    sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;${ANDROID_BUILD_TOOLS}" && \
    chmod +x ./gradlew
