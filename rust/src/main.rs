use actix_web::{web, App, HttpResponse, HttpServer};
use serde_json::json;

async fn hello() -> HttpResponse {
    HttpResponse::Ok().json(json!({"message": "Hello, world!"}))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/hello", web::get().to(hello))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
