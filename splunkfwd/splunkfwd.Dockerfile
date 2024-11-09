# Use the official Ubuntu image as the base
FROM sysbender/ufbase:latest

ARG INSTALLER
# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND noninteractive


# Define env variables only once and don't define it any more
ENV SPLUNK_HOME /opt/splunkforwarder
ENV SPLUNK_ROLE splunk_universal_forwarder
ENV SPLUNK_PASSWORD changemoi
ENV SPLUNK_START_ARGS --accept-license
# Install wget, tar, and any dependencies for Splunk
# RUN apt-get update && apt-get install -y \
#     wget \
#     tar \
#     expect \
#     && rm -rf /var/lib/apt/lists/*  # Clean up apt cache

RUN bash -c 'echo "INSTALLER: $INSTALLER" && \
    VERSION=$(echo $INSTALLER | sed -E "s/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/") && \
    echo "Detected version: $VERSION" && \
    URL="https://download.splunk.com/products/universalforwarder/releases/$VERSION/linux/$INSTALLER" && \
    echo "Download URL: $URL" && \
    wget -O /tmp/$INSTALLER $URL && \
    tar -xzf /tmp/$INSTALLER -C /opt/ && \
    rm /tmp/$INSTALLER'  # Clean up tarball after extraction 
# # Extract version from the installer filename (e.g., 9.3.1 from splunkforwarder-9.3.1-0b8d769cb912-Linux-x86_64.tgz)
# RUN env INSTALLER=$INSTALLER bash -c 'VERSION=$(echo $INSTALLER | sed -E "s/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/") && \
#     echo "Detected version: $VERSION" && \
#     URL="https://download.splunk.com/products/universalforwarder/releases/$VERSION/linux/$INSTALLER" && \
#     echo "Download URL: $URL" && \
#     wget -O /tmp/$INSTALLER $URL && \
#     tar -xzvf /tmp/$INSTALLER -C /opt/ && \
#     rm /tmp/$INSTALLER'  # Clean up tarball after extraction

# Expose Splunk's default port (optional, based on your use case)
EXPOSE 8089

# Set the working directory
WORKDIR $SPLUNK_HOME

# Optional: Set entrypoint to run Splunk (depends on your use case)
# ENTRYPOINT ["/opt/splunkforwarder/bin/splunk"]
# CMD ["start", "--accept-license"]

# The container will run in the background and be ready to configure/operate.
#https://habr.com/en/articles/447532/



# Everything is simple with shell scripts, but inputs.conf, splunkclouduf.spl and first_start.sh should have an explanation. I'll tell more about it below.
#COPY [ "inputs.conf", "docker-stats/props.conf", "/splunkforwarder/etc/system/local/" ]
#COPY [ "docker-stats/docker_events.sh", "docker-stats/docker_inspect.sh", "docker-stats/docker_stats.sh", "docker-stats/docker_top.sh", "/splunkforwarder/bin/scripts/" ]
COPY splunkclouduf.spl /splunkclouduf.spl
COPY ./scripts/first_start.sh $SPLUNK_HOME/bin/


# Copy the first_start.sh script from the host to the container
COPY ./scripts/first_start.sh /opt/splunkforwarder/bin/

# Add a RUN step to verify if first_start.sh is copied correctly
RUN ls -al /opt/splunkforwarder/bin/
#  Grant execute permissions, add user, execute pre-configuration
# RUN chmod a+x $SPLUNK_HOME/bin/*.sh \
#     && groupadd -g 999 -r splunk \
#     && useradd -u 999 -r -m -g splunk splunk \
#     && echo "%sudo ALL=NOPASSWD:ALL" >> /etc/sudoers \
#     && chown -R splunk:splunk $SPLUNK_HOME \
#     && $SPLUNK_HOME/bin/first_start.sh \
#     && $SPLUNK_HOME/splunk install app /splunkclouduf.spl -auth admin:changeme \
#     && $SPLUNK_HOME/bin/splunk restart


RUN echo " ============== SPLUNK_HOME is ${SPLUNK_HOME}"    
RUN chmod a+x $SPLUNK_HOME/bin/*.sh \
    && groupadd -g 999 -r splunk \
    && useradd -u 999 -r -m -g splunk splunk \
    && echo "%sudo ALL=NOPASSWD:ALL" >> /etc/sudoers \
    && chown -R splunk:splunk $SPLUNK_HOME 

RUN ls -al /opt/splunkforwarder/bin/

# RUN /opt/splunkforwarder/bin/splunk start --accept-license  --answer-yes --no-prompt --seed-passwd changemoi

RUN $SPLUNK_HOME/bin/first_start.sh \
    && $SPLUNK_HOME/bin/splunk install app /splunkclouduf.spl -auth admin:changemoi \
    && $SPLUNK_HOME/bin/splunk restart
    
# Copy init scripts
COPY [ "scripts/entrypoint.sh", "scripts/checkstate.sh", "/sbin/" ]

# It depends. If you need it locally - go on.
# VOLUME [ "/splunkforwarder/etc", "/splunkforwarder/var" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=3m --retries=5 CMD /sbin/checkstate.sh || exit 1

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD [ "start-service" ]
