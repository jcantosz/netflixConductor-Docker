FROM ubuntu

COPY tmp/startup.sh startup.sh
# DynomiteDB
RUN apt-get update -y \
    && apt-get install -y software-properties-common python-software-properties apt-transport-https \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FB3291D9 \
    && add-apt-repository "deb https://apt.dynomitedb.com/ trusty main" 

# NodeJS
RUN apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_6.x |  bash -

# Install Dependencies
#RUN apt-get install -y git cmake autoconf libtool gcc automake openssl-devel dynomitedb  java-1.8.0-openjdk-devel tomcat \
RUN apt-get install -y git dynomitedb nodejs build-essential default-jre default-jdk
    # Install Tomcat
RUN groupadd tomcat \
    && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat \
    && cd /tmp \
    && curl -O http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz \
    && mkdir /opt/tomcat \
    && tar -xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1 \
    && rm -rf apache-tomcat-8*tar.gz \
    && cd /opt/tomcat \
    && chgrp -R tomcat /opt/tomcat \
    && chmod -R g+r conf \
    && chmod g+x conf \
    && chown -R tomcat webapps/ work/ temp/ logs/
 
#    && systemctl enable tomcat



# Install Conductor
RUN mkdir netflix \
    && cd netflix \
    && git clone https://github.com/Netflix/conductor.git \
    && cd conductor




# Install dynomite
#RUN cd netflix
#    && git clone https://github.com/Netflix/dynomite.git

#RUN cd netflix
#    && git clone https://github.com:Netflix/conductor.git


# Add Dynomite to the path
#ENV PATH $PATH:/root/netflix/dynomite/src
EXPOSE 3000 8080
ENTRYPOINT ["/startup.sh"]
