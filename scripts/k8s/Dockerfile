FROM alpine:3.11.3
WORKDIR /code
RUN apk add --no-cache bash
COPY requirements.txt requirements.txt
COPY ~/repos/macbook/scripts/k8s/del_old_pods.sh /code/
CMD ["/code/del_old_pods.sh chrome"]
