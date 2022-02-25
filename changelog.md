# Changelog

Here you can find all the changes to this project. You can download either the `deb` package or our binary package for linux-64.

## [1.0.0] (2021-04-16)

This version has been tested with Nginx logs.

### Downloads

* [deb package](https://storage.googleapis.com/tbtail-releases/tbtail_1.0.0_amd64.deb)

* [binary file](https://storage.googleapis.com/tbtail-releases/tbtail_1.0.0_amd64)

### Fixes
- N/A


## [1.0.1] (2021-10-20)

This version is productive in all Tinybird servers with Nginx.

### Downloads

* [deb package](https://storage.googleapis.com/tbtail-releases/tbtail_1.0.0_amd64.deb)

* [binary file]()

### Fixes
- Changed append mode to use multipart instead of using the body of the request. This change has been made to avoid issues with the size of the request. Tinybird has the following [limits](https://docs.tinybird.co/api-reference/api-reference.html#limits-title)


## [1.1.0] (2022-02-11)

Added support for [HFI](https://docs.tinybird.co/api-reference/datasource-api.html#post-v0-events-title). Now you can decide to use HFI to send data or our regular API. If you want to use the HFI ingestion you need to run the tool using the `--hfi` flag. 

It is important to have in mind the HFI endpoint is intended to send events with a high rate at a small volume. Thus:
- Use low values in `send_frequency_ms`. Expected values will be around 500 - 1500 ms.
- Use low values in `send_bathc_size`. The HFI endopoint is not intended to be used with high data sizes so use a small number of events. In general, num_events * size_event < 

### Fixes
- Added support for [HFI](https://docs.tinybird.co/api-reference/datasource-api.html#post-v0-events-title).


## [1.1.0] (2022-02-17)

Added a new binary file for macOS (x86_64).

### Downloads

* [deb package](https://storage.googleapis.com/tbtail-releases/tbtail_1.1.0_amd64.deb)

* [binary file Linux](https://storage.googleapis.com/tbtail-releases/tbtail_1.1.0_linux_amd64)

* [binary file macOS](https://storage.googleapis.com/tbtail-releases/tbtail_1.1.0_macos_amd64)

### Fixes
- N/A


## [1.2.0] (2022-02-25)

Added support for Windows OS. 

### Downloads

* [deb package](https://storage.googleapis.com/tbtail-releases/tbtail_1.2.0_amd64.deb)

* [binary file Linux](https://storage.googleapis.com/tbtail-releases/tbtail_1.2.0_linux_amd64)

* [binary file macOS](https://storage.googleapis.com/tbtail-releases/tbtail_1.2.0_macos_amd64)

* [binary file Windows](https://storage.googleapis.com/tbtail-releases/tbtail_1.2.0_windows_amd64.exe)

### Fixes
- Changed the way of getting inode the log file, now is used package [syscall](https://pkg.go.dev/syscall) instead of [unix](https://pkg.go.dev/golang.org/x/sys/unix).
