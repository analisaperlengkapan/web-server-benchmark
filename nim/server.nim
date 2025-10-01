import jester

routes:
  get "/hello":
    resp """{"message": "Hello, world!"}""", "application/json"

runForever()
