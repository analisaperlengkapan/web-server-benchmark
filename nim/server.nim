import jester
import json

router myrouter:
  get "/hello":
    resp %*{"message": "Hello, world!"}, "application/json"

let settings = newSettings(port = Port(8080), bindAddr = "0.0.0.0")
var jester = initJester(myrouter, settings=settings)
jester.serve()
