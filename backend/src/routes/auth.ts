import { FastifyInstance } from 'fastify';
import pool from '../config/database';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'supersecretkey'; // Use variável ambiente segura!

export async function authRoutes(fastify: FastifyInstance) {

  // Rota de cadastro (signup)
  fastify.post('/signup', async (request, reply) => {
    const {
      name,
      email,
      password,
      userType,
      cpf,
      phone,
      institution,
      registrationNumber,
      course,
      photoUrl,
    } = request.body as {
      name: string;
      email: string;
      password: string;
      userType: 'aluno' | 'professor';
      cpf?: string;
      phone?: string;
      institution?: string;
      registrationNumber?: string;
      course?: string;
      photoUrl?: string;
    };

    const client = await pool.connect();

    try {
      // Verifica se email já existe
      const existingUser = await client.query(
        'SELECT id FROM users WHERE email = $1',
        [email]
      );

      if (existingUser.rowCount > 0) {
        client.release();
        return reply.status(400).send({ error: 'Email já cadastrado' });
      }

      // Hash da senha
      const passwordHash = await bcrypt.hash(password, 10);

      // Insere usuário no banco
      const insertResult = await client.query(
        `INSERT INTO users 
(name, email, password_hash, user_type, cpf, phone, institution, registration_number, course, photo_url, created_at, updated_at)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10, NOW(), NOW())
RETURNING id, name, email, user_type
        `,
        [
          name,
          email,
          passwordHash,
          userType,
          cpf || null,
          phone || null,
          institution || null,
          registrationNumber || null,
          course || null,
          photoUrl || null,
        ]
      );

      client.release();

      // Retorna sucesso com dados do usuário (sem senha)
      return {
        success: true,
        user: insertResult.rows[0],
      };
    } catch (error) {
      client.release();
      console.error('Erro ao cadastrar usuário:', error);
      return reply.status(500).send({ error: 'Erro ao cadastrar usuário' });
    }
  });

  // Rota de login
  fastify.post('/login', async (request, reply) => {
    const { email, password } = request.body as { email: string; password: string };

    const client = await pool.connect();

    try {
      // Busca usuário pelo email
      const userResult = await client.query(
        `SELECT id, name, email, password_hash, user_type FROM users WHERE email = $1`,
        [email]
      );

      if (userResult.rowCount === 0) {
        client.release();
        return reply.status(401).send({ error: 'Credenciais inválidas' });
      }

      const user = userResult.rows[0];

      // Compara senha
      const passwordMatch = await bcrypt.compare(password, user.password_hash);
      if (!passwordMatch) {
        client.release();
        return reply.status(401).send({ error: 'Credenciais inválidas' });
      }

      // Gera token JWT
      const token = jwt.sign(
        {
          userId: user.id,
          email: user.email,
          userType: user.user_type,
        },
        JWT_SECRET,
        { expiresIn: '12h' }
      );

      client.release();

      // Retorna token e dados do usuário (sem senha)
      return {
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          user_type: user.user_type,
        },
      };
    } catch (error) {
      client.release();
      fastify.log.error(error);
      return reply.status(500).send({ error: 'Erro ao fazer login' });
    }
  });
}
