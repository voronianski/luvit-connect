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

## License (MIT)

```
WWWWWW||WWWWWW
 W W W||W W W
      ||
    ( OO )__________
     /  |           \
    /o o|    MIT     \
    \___/||_||__||_|| *
         || ||  || ||
        _||_|| _||_||
       (__|__|(__|__|
```

Copyright (c) 2013 Dmitri Voronianski <dmitri.voronianski@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
