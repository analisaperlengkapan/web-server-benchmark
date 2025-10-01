var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/hello", () => new { message = "Hello, world!" });

app.Run("http://0.0.0.0:8080");
