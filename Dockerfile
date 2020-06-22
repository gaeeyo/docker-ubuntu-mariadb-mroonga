FROM ubuntu:bionic
RUN set -ex; apt-get update; \
  apt-get install -y -V --no-install-recommends software-properties-common gosu tzdata xz-utils; \
  add-apt-repository "deb http://security.ubuntu.com/ubuntu bionic-security main restricted"; \
  add-apt-repository -y ppa:groonga/ppa; \
  apt-get update; \
  apt-get install -y -V --no-install-recommends mariadb-server-10.1-mroonga; \
	rm -rf /var/lib/apt/lists/*; \
# comment out any "user" entires in the MySQL config ("docker-entrypoint.sh" or "--user" will handle user switching)
	sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/*; \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql /var/run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld; \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 777 /var/run/mysqld; \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/'; \
# don't reverse lookup hostnames, they are usually another container
	echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# for debug
# RUN set -ex; apt-get update; apt-get install -y -V --no-install-recommends vim less

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /usr/local/bin/
RUN set -ex; ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

RUN set -ex; mkdir /docker-entrypoint-initdb.d; ln -s /usr/share/mroonga/install.sql /docker-entrypoint-initdb.d/00-mroonga-install.sql

ENTRYPOINT ["/bin/bash", "docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
