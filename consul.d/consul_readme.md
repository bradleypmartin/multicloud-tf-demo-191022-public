# Consul config files (example; optional)

The JSON data here is an example of how a simple Consul configuration could be set up to test the Consul agent locally (pinging the HTTP services created in this demo).

## Overview

After installing Consul locally and adding it to my `$PATH`, I added the contents of the `consul.d` folder (aside from this README) to my local machine's home folder.

Next, in a first terminal window, I brought up the Consul Agent with the following command:

```
$ consul agent -dev -enable-script-checks -config-dir=./consul.d
```

If I wanted to see the status of a given service, I could check that in _another_ window with a command like the following (HTTP interface option):

```
$ curl http://localhost:8500/v1/health/service/azure_webserver
```

Another fun thing to do was to explore the Consul UI at `localhost:8500` via a browser window.
