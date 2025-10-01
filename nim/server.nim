import jester
import json

settings:
  port = Port(8080)
  bindAddr = "0.0.0.0"

routes:
  get "/hello":
    resp(%*{"message": "Hello, world!"}, "application/json")
