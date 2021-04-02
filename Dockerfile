FROM busybox
LABEL maintainer="jeromep@jfrog.com" description="JFrog pipelines sample"

USER foo:bar

ADD build dist