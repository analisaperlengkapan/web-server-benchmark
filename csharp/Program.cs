var builder = WebApplication.CreateSlimBuilder(args);
var app = builder.Build();

var response = new { message = "Hello, world!" };

app.MapGet("/hello", () => response);

app.Run("http://0.0.0.0:8080");
