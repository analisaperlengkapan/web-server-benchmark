#include "crow_all.h"

int main() {
    crow::SimpleApp app;

    CROW_ROUTE(app, "/hello")
    ([]() {
        crow::json::wvalue response;
        response["message"] = "Hello, world!";
        return response;
    });

    app.port(8080).multithreaded().run();
}
