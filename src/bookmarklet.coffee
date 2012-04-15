LOCAL = off
SERVER = if LOCAL then "http://localhost" else "http://50.116.7.184"

url = window.location.href
window.location.href = "#{SERVER}/static/handler.html?#{url}";