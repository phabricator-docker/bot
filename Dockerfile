FROM debian:stretch

RUN apt-get update && apt-get install -y \
		cron \
		git \
		ca-certificates \
		ssh \
		--no-install-recommends && rm -r /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/phabricator-docker/phabricator.git /app; \
	git fetch --all; \
	git submodule update --init --recursive;

RUN mkdir ~/.ssh; \
	{ \
		echo "Host *"; \
		echo "	StrictHostKeyChecking no"; \
		echo "	IdentitiesOnly yes"; \
		echo "	IdentityFile /run/secrets/ssh_key"; \
	} > ~/.ssh/config;

RUN git remote set-url origin git@github.com:phabricator-docker/phabricator.git; \
	git config --global user.name "Phabricator Docker"; \
	git config --global user.email "phabricator-docker@users.noreply.github.com";

COPY ./bin /bin

CMD ["/bin/start"]
