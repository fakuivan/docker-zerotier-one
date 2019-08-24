FROM centos:7

RUN yum update -y

COPY zt-install.sh /usr/bin/
RUN bash -c "/usr/bin/zt-install.sh || [[ -x /usr/sbin/zerotier-one ]]"

RUN yum clean all

VOLUME ["/var/lib/zerotier-one"]
CMD ["/usr/sbin/zerotier-one"]

