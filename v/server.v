module main

import veb
import json2

pub struct Context {
	veb.Context
}

pub struct App {
}

@['/hello']
pub fn (_ &App) hello(mut ctx Context) veb.Result {
	ctx.content_type = 'application/json'
	        response := json2.encode({'message': 'Hello, world!'}, json2.EncoderOptions{})
	return ctx.text(response)
}

fn main() {
	mut app := &App{}
	veb.run[App, Context](mut app, 8080)
}
