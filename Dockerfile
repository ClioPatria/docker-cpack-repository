FROM swipl

RUN apt-get update && apt-get install -y --no-install-recommends \
	imagemagick \
	graphviz \
	locales \
	curl \
	git

RUN     sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen
ENV     LC_ALL en_GB.UTF-8
ENV     LANG en_GB.UTF-8
ENV     LANGUAGE en_GB:en

ENV	CLIOPATRIA_VERSION a0b30a5e5ca7cd9adbea0cba98faca097e67600e
RUN     mkdir -p /srv && cd /srv && \
	git clone https://github.com/ClioPatria/ClioPatria.git && \
	git checkout $CLIOPATRIA_VERSION
RUN	mkdir -p /srv/cliopatria && cd /srv/cliopatria && \
	../ClioPatria/configure
COPY	users.db /srv/cliopatria/users.db
COPY	settings.db /srv/cliopatria/settings.db
RUN	cd /srv/cliopatria && \
	./run.pl cpack install cpack_repository swish
RUN	cd /srv/cliopatria/cpack/cpack_repository && \
	git remote set-url origin https://github.com/ClioPatria/cpack_repository &&\
	git pull
RUN	cd /srv/cliopatria/cpack/foaf && \
	git remote set-url origin https://github.com/ClioPatria/foaf && \
	git pull
RUN	cd /srv/cliopatria/cpack/foaf_user && \
	git remote set-url origin https://github.com/ClioPatria/foaf_user && \
	git pull
RUN	cd /srv/cliopatria/cpack/swish && \
	git remote set-url origin https://github.com/ClioPatria/swish && \
	git pull

# Running

copy health.sh health.sh
HEALTHCHECK --interval=30s --timeout=2m --start-period=1m CMD /health.sh

COPY start-cliopatria.sh /srv/start-cliopatria.sh

ENV CLIOPATRIA_DATA /srv/cliopatria/data
ENV CLIOPATRIA_HOME /srv/cliopatria
VOLUME ${CLIOPATRIA_DATA}
WORKDIR ${CLIOPATRIA_HOME}

ENTRYPOINT ["/srv/start-cliopatria.sh"]
