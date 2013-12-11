# luvit-connect

##### status: in progress

Luvit-connect is a port of [node.js](http://nodejs.org/)'s [connect](https://github.com/senchalabs/connect) middleware HTTP server framework for [luvit.io](http://luvit.io/).

### Usage

Luvit-connect contains nearly all middlewares that originally exist in node's version. Simple usage example can be as follows:

```lua
local connect = require('connect')
local http = require('http')

local app = connect.createServer()

app:use(connect.favicon())
app:use(connect.logger('dev'))
app:use(connect.static('public'))

http.createServer(app.handler).listen(8080)
```

### Middlewares

- cookieParser
- directory
- favicon
- json
- logger
- methodOverride
- query
- responseTime
- static
- timeout
- urlencoded

### Tests

---
(c) 2013 **MIT Licensed**
