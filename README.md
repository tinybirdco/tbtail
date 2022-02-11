# tbtail

`tbtail` is [Tinybird](https://tinybird.co)'s agent for ingesting log file data into Tinybird and making it available for exploration. Currently, it ingests all data into a string column of your data source. You'll have to extract each field, using JSONExtract function. You have detailed information about how you can do it in this [blog post](https://blog.tinybird.co/2021/01/28/nginx-log-analysis/).

`tbtail` is based on `clicktail` tool see [here](https://github.com/Altinity/clicktail).

## Supported Parsers

Unless our base tool `clicktail` supports several parsers, `tbtail` has only been tested with Nginx. Feel free to use other parsers if you feel confident enough.

The complete list of parsers can be found in the [`parsers/` directory](parsers/), but as of this writing there are:

- [ArangoDB](parsers/arangodb/)
- [MongoDB](parsers/mongodb/)
- [MySQL](parsers/mysql/)
- [PostgreSQL](parsers/postgresql/)
- [nginx](parsers/nginx/)
- [regex](parsers/regex/)
- [mysqlaudit](parsers/mysqlaudit/)

## Installation

There are three installation options for `tbtail`:
+ From [source code](#install-from-source-code)
+ From downloaded [`deb` package](#install-from-deb-package)
* Fron downloaded [`bin` package](#install-from-bin-package)

### Install from source code

1. Clone the [`tbtail`](https://github.com/tinybirdco/tbtail) and [`libtb-go`](https://github.com/tinybirdco/libtb-go) repo. 
2. Compile both using `go build`, `go install`, or create your makefile.

First of all, remember you should set your GOPATH var pointing to your go project folder.

Use go 1.14. It is not compatible with higher versions.

```
go get github.com/tinybirdco/tbtail
```

```
GOPATH=<go-project-folder> go build
GOPATH=<go-project-folder> go install
```

The binary will be installed into your bin folder `$GOPATH/bin/tbtail`

If you need to change anything highly probably you will need our `tblib-go` tool too.

```
go get github.com/tinybirdco/libtb-go
```

```
GOPATH=<go-project-folder> go build
GOPATH=<go-project-folder> go install
```

You can also use our [`Makefile`](./Makefile) to build, clean, install, and packaging the code.

- Use `make clean` to clean the project
- Use `make build` to build `tbtail`
- Use `make build-all` to build `tbtail` and `lib-tb`
- Use `make install` to install `tbtail`
- Use `make package` to build the .deb package

Remember that, in all cases, you need `GOPATH` to point to your root workspace.

### Releasing a new version

Everytime you create a new version remeber you need to bump the version in [version.txt](version.txt). It is important because the binary file, and the package file will contain the version you have generated.

Add all the changes to the [changelog](changelog.md) including the link to the binary file with the changes.

Do not forget to tag the code with the released version.

### Install from deb package

Download our latest package from [here](changelog.md).

Install the package as follows:

```sh
sudo dpkg -i tbtail_1.0.0_amd64.deb
```

After installing it you'll have:
- The binary file in `/usr/local/bin/tbtail`
- The configuration file in `/etc/tbtail/tbtail.conf`
- The service file in `/lib/systemd/system/tbtail.service`

You have detailed information about how to use the tool [here](#usage).

### Install from bin package

Download our latest package from [here](changelog.md).

You can place the binary file where you want and run it using the command line or a configuration file as explained in [Usage](#usage).

## Usage

Make sure you have created the data source in Tinybird that logs will be appended to. You can use the `nginx_raw.datasource` file: 

```sh
tb push datasource schema/tinybird/nginx_raw.datasource
tb push datasource schema/tinybird/nginx_log.datasource
tb push datasource schema/tinybird/nginx_mv.pipe
```

For a complete data project that will store the logs and materialize it with several granularity levels, you can check out [this project](https://github.com/tinybirdco/nginx-logs-analytics).

Once the Data Source is prepared to receive logs, you can run the binary as follows:

```sh
TB_WRITE_API_KEY=p.ey.. # token with either DATASOURCES:APPEND:nginx_raw, DATASOURCES:CREATE or ADMIN scope
tbtail --dataset nginx_raw --parser nginx --file /var/log/nginx/access.log --nginx.conf /etc/nginx/nginx.conf --nginx.format combined --writekey $TB_WRITE_API_KEY
```

You can also run the binary using a config file like [tbtail.conf](./tbtail.conf). This file contains a description for each available option.

If you have installed our package you can manage the service using `systemctl` command:  

```sh
sudo systemctl start tbtail
sudo systemctl stop tbtail
sudo systemctl restart tbtail
systemctl status tbtail
```

## Development

Make sure you have go 1.14. It is not compatible with higher versions.

