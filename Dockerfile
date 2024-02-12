FROM swipl:stable

RUN apt-get update && apt-get install -y --no-install-recommends \
	imagemagic

RUN     sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen
ENV     LC_ALL en_GB.UTF-8
ENV     LANG en_GB.UTF-8
ENV     LANGUAGE en_GB:en

RUN     mkdir -p /srv && cd /srv && \
	git clone -b docker https://github.com/ClioPatria/ClioPatria.git
RUN	mkdir -p /srv/cliopatria && cd /srv/cliopatria && \
	../ClioPatria/configure
COPY	users.db /srv/cliopatria/users.db
COPY	settings.db /srv/cliopatria/settings.db
RUN	cd /srv/cliopatria && \
	./run.pl cpack install cpack_repository

# Running

copy health.sh health.sh
#HEALTHCHECK --interval=30s --timeout=2m --start-period=1m CMD /health.sh

COPY start-cliopatria.sh /srv/start-cliopatria.sh

ENV CLIOPATRIA_DATA /srv/cliopatria/data
ENV CLIOPATRIA_HOME /srv/cliopatria
VOLUME ${PLWEB_DATA}
WORKDIR ${PLWEB_HOME}

ENTRYPOINT ["/srv/start-cliopatria.sh"]
