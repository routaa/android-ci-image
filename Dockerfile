ARG JDK_IMAGE
FROM $JDK_IMAGE

ARG ANDROID_COMPILE_SDK
ARG ANDROID_BUILD_TOOLS
ARG ANDROID_SDK_TOOLS
ARG ANDROID_NDK

# Add bundle signer for cafe bazzar bundle signing 

ENV BUNDLE_SIGNER_DIR "/bazzar-bundlesigner"
ENV BUNDLE_SINGER_1_13_MD5_HASH "cb7d17904d680f1ae4c90de9827af6e2"

RUN mkdir $BUNDLE_SIGNER_DIR && cd $BUNDLE_SIGNER_DIR
RUN wget https://github.com/cafebazaar/bundle-signer/releases/download/v0.1.12/bundlesigner-0.1.12.jar
RUN [ $(md5sum bundlesigner-0.1.12.jar | awk '{print $1}') == $BUNDLE_SINGER_1_13_MD5_HASH ] && echo -e "MD5 checksum verfied" || { echo "Checksum failed" && exit 1;}

# Installing the required sdk
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
RUN echo $ANDROID_BUILD_TOOLS | xargs -i sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;{}"
