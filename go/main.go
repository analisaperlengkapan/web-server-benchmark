package main

import (
	"github.com/gofiber/fiber/v2"
)

type Response struct {
	Message string `json:"message"`
}

func main() {
	app := fiber.New(fiber.Config{
		DisableStartupMessage: true,
	})

	app.Get("/hello", func(c *fiber.Ctx) error {
		return c.JSON(Response{Message: "Hello, world!"})
	})

	app.Listen(":8080")
}
