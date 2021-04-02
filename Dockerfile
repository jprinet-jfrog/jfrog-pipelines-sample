FROM busybox
LABEL maintainer="jeromep@jfrog.com" description="JFrog pipelines sample"

ARG ARCHIVE_PATH=foo

USER foo:bar

ADD ${ARCHIVE_PATH}/build dist