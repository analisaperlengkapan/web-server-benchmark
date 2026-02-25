const fastify = require('fastify')({
  logger: false
});

fastify.get('/hello', async (request, reply) => {
  return { message: 'Hello, world!' };
});

fastify.listen({ port: 8080, host: '0.0.0.0' }, (err, address) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(`Server listening on ${address}`);
});
