
## Server

To get the server running,

```coffee
npm install
coffee src/server.coffee
open http://localhost:5000
```

Run this in a new terminal window
```
coffee -w -o js/ -c src/*.coffee
```


## Endpoints

* /new with geolocation

Messsaging:

id -> {name, geolocation, ip}
frisbee -> do animation, etc. 