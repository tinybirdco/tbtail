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

```
go get https://github.com/tinybirdco/tbtail
```

```
GOPATH=<go-project-folder> go build
GOPATH=<go-project-folder> go install
```

The binary will be installed into your bin folder `$GOPATH/bin/tbtail`

If you need to change anything highly probably you will need our `tblib-go` tool too.

```
go get https://github.com/tinybirdco/libtb-go
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

Make sure you have created the data source in Tinybird. You can use the `nginx_1.datasource` file: 

```sh
tb push datasource schema/tinybird/nginx_raw.datasource
```

Once datasource is prepared you can run binary as follows:

```sh
tbtail --dataset nginx_1 --parser nginx --file /var/log/nginx/access.log --nginx.conf /etc/nginx/nginx.conf --nginx.format combined --writekey p.eyJ1IjogIjMzNjU3ODViLTRlNTYtNDY3MS1iMGUzLThjNjUzOTJiODhlYSIsICJpZCI6ICJiOTMwZjMyMi00MGYyLTQ5MDYtYWYxYi1jMjNiMWE2MmJkNWUifQ.AjCuIPMjMzzp_zprh_8ha2ALe4CMjOBOQOGyQALde-M
```

You can also run the binary using a config file like [tbtail.conf](./tbtail.conf). This file contains a description for each available option.

If you have installed our package you can manage the service using `systemctl` command:  

```sh
sudo systemctl start tbtail
sudo systemctl stop tbtail
sudo systemctl restart tbtail
systemctl status tbtail
```