import Fastify from 'fastify';
import dotenv from 'dotenv';
import { authRoutes } from './routes/auth';
import pool from './config/database';

dotenv.config();

const PORT = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;
const HOST = process.env.HOST || '0.0.0.0';

const fastify = Fastify({
  logger: true, // ativa logs para debug
});

// Registro das rotas (auth etc)
fastify.register(authRoutes);

// Rota de teste simples para verificar servidor e banco
fastify.get('/ping', async (request, reply) => {
  try {
    const client = await pool.connect();
    const res = await client.query('SELECT NOW()');
    client.release();
    return { message: 'Servidor rodando! Banco respondeu com:', time: res.rows[0].now };
  } catch (error) {
    fastify.log.error(error);
    return reply.status(500).send({ error: 'Erro ao conectar no banco' });
  }
});

// Inicialização do servidor
const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: HOST });
    console.log(`Servidor rodando em http://${HOST}:${PORT}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
