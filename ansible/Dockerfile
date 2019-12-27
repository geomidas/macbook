FROM alpine:3.10.2

LABEL version="1.0.0" 
LABEL maintainer="Georgios Keramidas"

# Instructions:
# 1. Build this image. 
#    Example: 
#       sudo docker build -t 'ansible-playbook:1.0.0' ~/repos/macbook/ansible
#
# 2. Create a text file with your password in it: ~/.ansible/.ansible_vaulpas
#
# 3. Run the image, specifying an ansible account and mounting your password file
#    Example: 
#       sudo docker run -u ansible -v ~/.ssh:/home/ansible/.ssh -v ~/.ansible/.ansible_vaulpas:/home/ansible/.ansible/.vaulpas -t 'ansible-playbook:1.0.0' ~/repos/sysadmin/ansible 

ENV ANSIBLE_VERSION 2.8.5

ENV BUILD_PACKAGES \
    bash \
    curl \
    tar \
    openssh-client \
    sshpass \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-yaml \
    ca-certificates

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
    sudo \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
    \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip install --upgrade pip && \
    pip install python-keyczar docker-py && \
    \
    echo "==> Creating ansible account..."  && \
    adduser -D -h /home/ansible -s '/bin/bash' -G 'wheel' ansible && \
#    mkdir /home/ansible/.ansible && \
#    chmod 700 /home/ansible/.ssh && \
#    chmod 600 /home/ansible/.ssh/authorized_keys && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

# Copy ansible roles, config and hosts
COPY ~ansible/.ansible /home/ansible/
COPY ~ansible/.ssh /home/ansible/
COPY ./* /home/ansible/repos/sysadmin/ansible/
COPY roles/ansible_server/files/hosts /etc/ansible/
COPY roles/ansible_server/files/ansible.cfg /etc/ansible/

RUN chown -R ansible:wheel /home/ansible

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /home/ansible/repos/macbook/ansible/roles
ENV ANSIBLE_LIBRARY /ansible/library
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH

WORKDIR /home/ansible

#ENTRYPOINT ["ansible-playbook"]
ENTRYPOINT ["bash"]
