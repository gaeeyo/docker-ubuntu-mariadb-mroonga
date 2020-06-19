
# 概要

docker 使い始めたので練習。

ubuntu 18.04 に mariadb-server-mroonga をインストールしたイメージ。
mariadb が公開している mariadb/server の docker-entrypoint.sh をそのまま使っているので、environment の仕様はそのまま。


# メモ

使い方をすぐ忘れるので docker コマンドのメモ。
```
set -ex; docker build -t mroonga .; docker run --rm -it -eMYSQL_ALLOW_EMPTY_PASSWORD=1 mroonga bash
```
```
docker exec -it set -ex; docker build -t mroonga .; docker run --rm -it -eMYSQL_ALLOW_EMPTY_PASSWORD=1 mroonga bash
```

# リンク


- [mariadb/server by mariadb](https://hub.docker.com/r/mariadb/server)
 ([github](https://www.github.com/mariadb-corporation/mariadb-server-docker))
- [mariadb by Docker Official Images](https://hub.docker.com/_/mariadb/)
 ([github](https://github.com/docker-library/mariadb))
- [groonga/mroonga by groonga](https://hub.docker.com/r/groonga/mroonga/)
 ([github](https://github.com/mroonga/docker))
