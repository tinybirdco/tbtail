# clicktail

`clicktail` is [Altinity](https://altinity.com)'s agent for ingesting log file data into ClickHouse and making it available for exploration. Its favorite format is **JSON**, but understands how to parse a range of other well-known log formats.

`clicktail` is based on `honeytail` tool see [here](https://github.com/honeycombio/honeytail) and [its documentation](https://honeycomb.io/docs/send-data/agent/)

## Supported Parsers

`clicktail` supports reading files from `STDIN` as well as from a file on disk.

Our complete list of parsers can be found in the [`parsers/` directory](parsers/), but as of this writing, `clicktail` will support parsing logs generated by:

- [ArangoDB](parsers/arangodb/)
- [MongoDB](parsers/mongodb/)
- [MySQL](parsers/mysql/)
- [PostgreSQL](parsers/postgresql/)
- [nginx](parsers/nginx/)
- [regex](parsers/regex/)

## Installation

There are three installation options for clicktail:
+ From package repository
+ From downloaded package
+ From source

#### Install from `deb` package repository:

```
curl -s https://packagecloud.io/install/repositories/Altinity/clickhouse/script.deb.sh | bash
```
if you want to force `os` and `dist` of your system, use the following command:

```
curl -s https://packagecloud.io/install/repositories/Altinity/clickhouse/script.deb.sh | os=ubuntu dist=xenial bash
```

Then install clicktail itself:
```
apt-get install clicktail
```

#### Install from individual `deb` package

Download and install the package from here: https://packagecloud.io/Altinity/clickhouse

#### Install from source:

```
go get github.com/Altinity/clicktail
```

to install to a specific path:

```
GOPATH=/usr/local go get github.com/Altinity/clicktail
```

the binary will install to `/usr/local/bin/clicktail`

## Configuration

Clicktail supports command line options as well as configuration file. In fact the file is not picked up by default when you are running `clicktail` from CLI so one should explicitly specify it with `-c` option.

Use `clicktail.conf` file to manage options. There are section of the file called `Required Options` which should be set in the first place.

#### Config Example

`/etc/clicktail/clicktail.conf`
```
[Application Options]
APIHost = http://localhost:8123/
...
[Required Options]
ParserName = mysql
LogFiles = /var/log/mysql/mariadb-slow.log
Dataset = clicktail.mysql_slow_log
```

## Usage

Make sure ClickHouse server has proper schema created. See `schema` folder for `CREATE DATABASE` and `CREATE TABLE` statements.

Or do the following:

Create DB:
```
cat schema/db.sql | clickhouse-client --multiline
```

Create Table for MySQL slow logs:
```
cat schema/mysql.sql | clickhouse-client --multiline
```

Once schema is prepared you can run binary from CLI with MySQL parser:
```
clicktail --dataset='clicktail.mysql_slow_log' --parser=mysql --file=/var/log/mysql/mysql-slow.log
```

Or with Nginx parser:

```
clicktail -p nginx -f /var/log/nginx/access.log -d clicktail.nginx_log --nginx.conf=/etc/nginx/nginx.conf --nginx.format=combined
```

After you done with checking out your configuration options, you will need to store them in `clicktail.conf` in order to run `clicktail` as a service just like that:

```
service clicktail start
```

## ClickHouse Setup

Clicktail is required ClickHouse to be accessible as a target server. So you should have ClickHouse server installed.

Follow these steps in order to install ClickHouse server and make it work with Clicktail.

Once you installed Clickhouse you whould probably need it to be open to outside connections. In order to do so update `/etc/clickhouse-server/config.xml` to add the following line:

`<listen_host>0.0.0.0</listen_host>`

just after: `<listen_host>127.0.0.1</listen_host>`

Also make sure ClickHouse port (which is `8123` by default) is open with your firewall.


For more advanced usage, options, and the ability to scrub or drop specific fields, see [documentation](https://honeycomb.io/docs/send-data/agent).

