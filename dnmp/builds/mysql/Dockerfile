# Base image
# FROM mysql:5.7
ARG MYSQL_VERSION
FROM ${MYSQL_VERSION}
ARG MYSQL_VERSION

# Copy starting scripts file
COPY ./start.sh /root/start.sh
RUN chmod +x /root/start.sh
# Run necessary services
CMD ["/bin/bash", "/root/start.sh"]
#ENTRYPOINT ["sh", "-c", "./start.sh"]