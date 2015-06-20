FROM centos:centos7
MAINTAINER Chakravarthy Nelluri <chakri@datawise.io>

RUN yum -y install java wget tar && yum clean all

RUN wget -q -O - http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/stable/zookeeper-3.4.6.tar.gz | tar -zx -C /opt

RUN ln -s /opt/zookeeper-3.4.6 /opt/zookeeper

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
