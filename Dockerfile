FROM ruby:2.7.1

ENV RAILS_ENV test
ENV NODE_ENV test
ENV GRADLE_HOME=/opt/gradle/gradle-5.4.1
ENV ANDROID_HOME=/opt/android
ENV PATH=$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs build-essential git curl software-properties-common libpq-dev imagemagick wkhtmltopdf xvfb tesseract-ocr && \
    npm install -g yarn

RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update && \
    apt install -y openjdk-8-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

RUN wget https://services.gradle.org/distributions/gradle-5.4.1-bin.zip -P /tmp \
    && unzip -d /opt/gradle /tmp/gradle-5.4.1-bin.zip \
    && mkdir /opt/gradlew \
    && /opt/gradle/gradle-5.4.1/bin/gradle wrapper --gradle-version 5.4.1 --distribution-type all -p /opt/gradlew \
    && /opt/gradle/gradle-5.4.1/bin/gradle wrapper -p /opt/gradlew

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp \
    && unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
    && yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "platforms;android-28" "build-tools;28.0.3" \
    && yes Y | /opt/android/tools/bin/sdkmanager --licenses

RUN apt-get update && apt-get install -y jq
