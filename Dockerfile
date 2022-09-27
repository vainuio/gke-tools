FROM docker:stable

WORKDIR /gke-tools

ARG HELM_VERSION=3.10.0
ARG KUBECTL_VERSION=1.25.2
ARG GCLOUD_VERSION=403.0.0


RUN apk add --update --no-cache python3 py3-pip git curl ca-certificates bash make


ENV HELM_BASE_URL="https://get.helm.sh"
ENV HELM_TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN curl -L ${HELM_BASE_URL}/${HELM_TAR_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git && \
    rm -rf linux-amd64


RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


ENV GCLOUD_BASE_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/"
ENV GCLOUD_TAR_FILE="google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz"
ENV PATH="${PATH}:/gke-tools/google-cloud-sdk/bin"
RUN curl -L ${GCLOUD_BASE_URL}/${GCLOUD_TAR_FILE} | tar xvz && \
    chmod +x ./google-cloud-sdk/install.sh && \
    ./google-cloud-sdk/install.sh --quiet
