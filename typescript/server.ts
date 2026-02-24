import Fastify from 'fastify';

const fastify = Fastify({
  logger: false
});

fastify.get('/hello', async (request, reply) => {
  return { message: 'Hello, world!' };
});

const start = async () => {
  try {
    await fastify.listen({ port: 8080, host: '0.0.0.0' });
    console.log('Server running on port 8080');
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};
start();
