module main

import vweb
import json

struct App {
	vweb.Context
}

pub fn (mut app App) index() vweb.Result {
	app.set_content_type('application/json')
	response := json.encode({'message': 'Hello, world!'})
	return app.text(response)
}

fn main() {
	mut app := &App{}
	vweb.run(app, 8080)
}
