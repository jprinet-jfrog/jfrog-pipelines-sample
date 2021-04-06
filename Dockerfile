FROM busybox
LABEL maintainer="jeromep@jfrog.com" description="JFrog pipelines sample"

# add Gradle build output
ADD build dist

# init httpd index
RUN echo "Hello Pipelines from Docker" > "/var/www/index.html"

# run httpd server
CMD ["httpd" ,"-f" ,"-p" ,"80" ,"-h", "/var/www/"]