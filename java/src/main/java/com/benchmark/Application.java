package com.benchmark;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.DeploymentOptions;
import io.vertx.ext.web.Router;

public class Application extends AbstractVerticle {

  @Override
  public void start() {
    Router router = Router.router(vertx);

    router.get("/hello").handler(ctx -> {
      ctx.response()
        .putHeader("content-type", "application/json")
        .end("{\"message\":\"Hello, world!\"}");
    });

    vertx.createHttpServer()
      .requestHandler(router)
      .listen(8080);
  }

  public static void main(String[] args) {
    Vertx vertx = Vertx.vertx();
    int procs = Runtime.getRuntime().availableProcessors();
    vertx.deployVerticle(Application.class.getName(), new DeploymentOptions().setInstances(procs));
    System.out.println("Server started on port 8080 with " + procs + " instances");
  }
}
