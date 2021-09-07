 FROM ubuntu:20.04

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

#우분투 업데이트, git 관련설치
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y git curl \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install -y git-lfs \
 && git lfs install \
 && rm -rf /var/lib/apt/lists/*

#각종 유틸 설치
RUN apt-get update \    
 && apt-get install -y unzip \    
 && apt-get install -y wget \    
 && apt-get install -y vim

#JDK 설치 및 환경변수 등록
ENV DEBIAN_FRONTEND=noninteractive
RUN 6 | apt-get install -y openjdk-8-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

#nodejs 설치 및 npm install
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs

#Gradle 설치 및 환경변수 등록
ADD https://services.gradle.org/distributions/gradle-6.7-all.zip /opt/
RUN unzip /opt/gradle-6.7-all.zip -d /opt/gradle
ENV GRADLE_HOME /opt/gradle/gradle-6.7
ENV PATH $GRADLE_HOME/bin:$PATH

#Android SDK 설치, 라이센스 등록, 환경변수 등록(sdk 버전 30, 29)
RUN apt-get update && apt-get -y install mc && mkdir /var/android-sdk && cd /var/android-sdk
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools-linux-4333796.zip
RUN mv tools /var/android-sdk/
RUN cd /var/android-sdk/tools/bin/
RUN yes | /var/android-sdk/tools/bin/sdkmanager --update
RUN yes | /var/android-sdk/tools/bin/sdkmanager --licenses
RUN yes | /var/android-sdk/tools/bin/sdkmanager --list
RUN yes | /var/android-sdk/tools/bin/sdkmanager \
"tools" \
"platform-tools" \
"build-tools;31.0.0" \
"platforms;android-30" \
"build-tools;30.0.2" \
"platforms;android-29" \
"build-tools;29.0.2" \ 
"platforms;android-28" \
"extras;android;m2repository" \
"extras;google;m2repository"
RUN rm -r sdk-tools-linux-4333796.zip

# fastlane 설치
RUN apt install ruby-dev -y
RUN export LC_ALL=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt-get update
RUN apt-get install build-essential -y
RUN gem install google-api-client
RUN gem install fastlane -NV

# npm 설치
RUN npm install -legacy-peer-deps

