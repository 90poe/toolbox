FROM golang:alpine as go-builder
RUN apk add --no-cache git

# Install assume-role
RUN go get -u github.com/remind101/assume-role

FROM python:3-alpine
RUN apk add --no-cache bash curl git openssh-client make git-crypt postgresql-client jq go kafkacat screen openvpn
WORKDIR /root
RUN mkdir bin/
COPY --from=go-builder /go/bin/assume-role bin/assume-role

# Install rest tools
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" \
	-o "awscli-bundle.zip" \
        && unzip awscli-bundle.zip \
        && ./awscli-bundle/install -i /usr/local/aws -b bin/aws \
	&& rm -rf awscli-bundle* \
    && curl -o bin/aws-iam-authenticator \
	"https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator" \
        && chmod +x bin/aws-iam-authenticator \
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
        && chmod +x ./kubectl \
        && mv ./kubectl bin/ \
    && curl "https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip" \
        -o "vault.zip" \
        && unzip vault.zip \
        && mv vault bin/ \
        && rm -rf vault.zip \
    && curl "https://get.helm.sh/helm-v2.16.7-linux-amd64.tar.gz" \
	-o "helm.tar.gz" \
	&& tar xvf helm.tar.gz \
	&& mv linux-amd64/helm bin/ \
	&& rm -rf linux-amd64 helm.tar.gz \
    && git clone "https://github.com/tfutils/tfenv.git" ~/.tfenv \
	&& ln -s ~/.tfenv/bin/* ~/bin \
	&& bin/tfenv install \
	&& bin/tfenv use \
    && curl "https://s3-eu-west-1.amazonaws.com/90poe-tools-infrastructure/software/cli/ovpn-generator/ovpn-generator-linux-out.zip" \
	-o ovpn-generator-linux-out.zip \
	&& unzip ovpn-generator-linux-out.zip \
	&& mv ovpn-generator-linux bin/ovpn-generator \
	&& chmod +x bin/ovpn-generator \
    && curl -o bin/fly \
	"https://concourse.tools.devopenocean.studio/api/v1/cli?arch=amd64&platform=linux" \
	&& chmod +x bin/fly \
    && curl -o bin/templater \
	"https://cdn.openocean.studio/utils/templater/templater-linux" \
	&& chmod +x bin/templater

COPY bashrc ./.bashrc
COPY screenrc ./.screenrc
ENV PATH="/root/bin:${PATH}"
ENV BASH_ENV="/root/.bashrc"
SHELL ["/bin/bash", "-l", "-c"]

ENTRYPOINT ["/bin/bash"]
