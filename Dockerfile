
FROM openjdk:8-jre-alpine

# Expose ports
EXPOSE 8080

# Add tags
LABEL \
  maintainer="The Petals team" \
  contributors="Pierre Souquet (Linagora), Vincent Zurczak (Linagora)" \
  github="https://github.com/petalslink"

# Build arguments & variables
ARG COCKPIT_VERSION="LATEST"
ENV DOWNLOAD_URL="https://gitlab.com/linagora/petals-cockpit/builds/artifacts/"

# Copy the script (first)
COPY docker-wrapper.sh /opt/petals-cockpit/docker-wrapper.sh

# FIXME: unable to get the latest tag of gitlab without specific tag :
# see https://gitlab.com/gitlab-org/gitlab-ce/issues/22273
# and https://gitlab.com/gitlab-org/gitlab-ce/issues/26254
# For now latest tag must be updated each release of cockpit.
# Important: temporary system packages are deleted at the end.
RUN apk update  && \
  apk add curl bash && \
  rm -rf /var/cache/apk/* && \
  apk upgrade  && \
  { [ "${COCKPIT_VERSION}" = "LATEST" ] && export DOWNLOAD_URL="${DOWNLOAD_URL}v0.23.0/download?job=release-product"; } || \
  { [ "${COCKPIT_VERSION}" = "SNAPSHOT" ] && export DOWNLOAD_URL="${DOWNLOAD_URL}master/download?job=package-product-master"; } || \
  { export DOWNLOAD_URL="${DOWNLOAD_URL}${COCKPIT_VERSION}/download?job=release-product"; } && \
  echo "Downloading ${COCKPIT_VERSION}: ${DOWNLOAD_URL}" && \
  curl -L "${DOWNLOAD_URL}" -o /tmp/petals-cockpit.zip --silent && \
  mkdir /tmp/petals-cockpit-zip && \
  unzip /tmp/petals-cockpit.zip -d /tmp/petals-cockpit-zip && \
  cp -r /tmp/petals-cockpit-zip/petals-cockpit-*/* /opt/petals-cockpit && \
  rm -rf /tmp/petals-cockpit* && \
  chmod 775 /opt/petals-cockpit/docker-wrapper.sh && \
  apk del curl  

# Set the working directory
WORKDIR /opt/petals-cockpit

# Indicate the default script
CMD /opt/petals-cockpit/docker-wrapper.sh
