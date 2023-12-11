ARG JDK_IMAGE
FROM $JDK_IMAGE

ARG ANDROID_COMPILE_SDK
ARG ANDROID_BUILD_TOOLS
ARG ANDROID_SDK_TOOLS
ARG ANDROID_NDK

ENV ANDROID_HOME="/android-home"
ENV PATH=$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin/

RUN \
    install -d $ANDROID_HOME && \
    wget --output-document=$ANDROID_HOME/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip && \
    unzip -d $ANDROID_HOME/cmdline-tools $ANDROID_HOME/cmdline-tools.zip && \
    find $ANDROID_HOME && \
    rm -f $ANDROID_HOME/cmdline-tools.zip && \
    sdkmanager --version && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses || true

RUN sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools"
RUN sdkmanager --install "ndk;${ANDROID_NDK}"
RUN sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}"
RUN /bin/bash -c "IFS='-' read -r -a buildToolsArray <<< '${ANDROID_BUILD_TOOLS}' && for buildToolsVersion in ${buildToolsArray[@]}; do sdkmanager --sdk_root=${ANDROID_HOME} 'build-tools;${buildToolsVersion}' ; done"
