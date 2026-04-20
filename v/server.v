module main

import veb
import json

pub struct Context {
	veb.Context
}

pub struct App {
}

@['/hello']
pub fn (_ &App) hello(mut ctx Context) veb.Result {
	ctx.content_type = .json
	response := json.encode({'message': 'Hello, world!'})
	return ctx.text(response)
}

fn main() {
	app := &App{}
	veb.run[App, Context](app, 8080)
}
