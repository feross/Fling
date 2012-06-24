Fling Readme
============

Developed by [Abi Raja](http://abi.sh), [Feross Aboukhadijeh](http://feross.org), and Alex Hicks-Nelson for [Stanford ACM](http://stanfordacm.com) Big Hack 2012. We won second place.

Fling your content around!
--------------------------

Fling is an iPhone app and bookmarklet that let's you fling content (like music, web urls, and youtube videos) from your phone onto a nearby computer. The computer you're sending too only needs a web browser to receive flings. We also built a Mac app so if you're a regular flinger you can fling without even opening a browser window! This is super handy if you like to continue listening to your iPod music on your desktop speakers when you get home.

## How to Run It

The server is written in Node.js and CoffeeScript. Objective C for the Mac and iPhone apps and JavaScript for the bookmarklet, of course. All the code is hackathon-quality and we haven't touched it since the hackathon, so we make no guarantees about code quality or runability of anything! Here be dragons...

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