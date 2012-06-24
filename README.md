Fling Readme
============

Developed by [Abi Raja](http://abi.sh), [Feross Aboukhadijeh](http://feross.org), and Alex Hicks-Nelson for *[Stanford ACM](http://stanfordacm.com) Big Hack 2012*.

We won second place, $500 each, and a sweet star wars lightsaber :). Thanks Ness Computing!

## Fling your content around!

Fling an iPhone app and bookmarklet that let's you *fling* content (like music, web urls, and youtube videos) from your phone onto a nearby computer. It's handy for sharing with friends.

## How to Run It

Code is hackathon-quality and we haven't touched it since, so no guarantees about anything!

### Server

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

### Endpoints

* /new with geolocation

Messsaging:

id -> {name, geolocation, ip}
frisbee -> do animation, etc.