# tbtail

`tbtail` is [Tinybird](https://tinybird.co)'s agent for ingesting log file data into Tinybird and making it available for exploration. Currently, it ingest all data into an string column of your datasource. You'll have to extract each field, using JSONExtract fuction. You  have detailed information about how you can do it in this [blog post](https://blog.tinybird.co/2021/01/28/nginx-log-analysis/).

`tbtail` is based on `clicktail` tool see [here](https://github.com/Altinity/clicktail).

## Supported Parsers

Unless our base tool `clicktail` supports several parsers, `tbtail` has only being tested with nginx. Feel free to use other parsers at your own.

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
+ From source code
+ From downloaded package

### Install from source code

1. Clone the [`tbtail`](https://github.com/ygnuss/tbtail) and [`libtb-go`](https://github.com/ygnuss/libtb-go) repo. 
2. Compile both using `go build`, `go install` or create your own makefile.

First of all, remember you  should set your GOPATH var pointing to your go project folder.

```
go get https://github.com/ygnuss/tbtail
```

```
GOPATH=<go-project-folder> go build
GOPATH=<go-project-folder> go install
```

The binary will be installed into your bin folder `$GOPATH/bin/tbtail`

If you need to change anything highly probably you will need our `tblib-go` tool too.

```
go get https://github.com/ygnuss/libtb-go
```

```
GOPATH=<go-project-folder> go build
GOPATH=<go-project-folder> go install
```

You can also use our [`Makefile`](./Makefile) to build, clean, install and packaging the code.

- Use `make clean` to clean the project
- Use `make build` to build `tbtail`
- Use `make build-all` to build `tbtail` and `lib-tb`
- Use `make install` to install `tbtail`
- Use `make package` to build the .deb package

Remember that, in all cases, you need `GOPATH` point to your root workspace.

### Install from package

<TBC>



## Usage

Make sure you have created the data source in Tinybird. You can use the `nginx_1.datasource` file: 

```sh
tb push datasource nginx_1.datasource
```

Once datasource is prepared you can run binary as follows:

```sh
tbtail --dataset nginx_1 --parser nginx --file /var/log/nginx/access.log --nginx.conf /etc/nginx/nginx.conf --nginx.format combined --writekey p.eyJ1IjogIjMzNjU3ODViLTRlNTYtNDY3MS1iMGUzLThjNjUzOTJiODhlYSIsICJpZCI6ICJiOTMwZjMyMi00MGYyLTQ5MDYtYWYxYi1jMjNiMWE2MmJkNWUifQ.AjCuIPMjMzzp_zprh_8ha2ALe4CMjOBOQOGyQALde-M
```

You can also run the binary using a config file like [tbtail.conf](./tbtail.conf). This file contains a description for each available option.