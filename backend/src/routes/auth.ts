import { FastifyInstance, FastifyPluginAsync } from 'fastify';
import pool from '../config/database';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'supersecretkey';

export const authRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {

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
      const existingUser = await client.query(
        'SELECT id FROM users WHERE email = $1',
        [email]
      );

      if (existingUser.rowCount && existingUser.rowCount > 0) {
        client.release();
        return reply.status(400).send({ error: 'Email já cadastrado' });
      }

      const passwordHash = await bcrypt.hash(password, 10);

      const insertResult = await client.query(
        `INSERT INTO users 
(name, email, password_hash, user_type, cpf, phone, institution, registration_number, course, photo_url, created_at, updated_at)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10, NOW(), NOW())
RETURNING id, name, email, user_type, photo_url`,
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

      return reply.status(201).send({
        success: true,
        user: insertResult.rows[0], 
      });

    } catch (error) {
      client.release();
      console.error('Erro ao cadastrar usuário:', error);
      return reply.status(500).send({ error: 'Erro ao cadastrar usuário' });
    }
  });

  fastify.post('/login', async (request, reply) => {
  console.log('=== INÍCIO DA REQUISIÇÃO DE LOGIN ===');
  console.log('Corpo da requisição recebida:', JSON.stringify(request.body, null, 2));
  
  const { email, password } = request.body as {
    email: string;
    password: string;
  };

  console.log('Tentativa de login para o email:', email);
  
  if (!email || !password) {
    console.error('Email ou senha não fornecidos');
    return reply.status(400).send({ error: 'Email e senha são obrigatórios' });
  }

  const client = await pool.connect();

  try {
    console.log('Buscando usuário no banco de dados...');
    const userResult = await client.query(
      `SELECT id, name, email, password_hash, user_type, photo_url FROM users WHERE email = $1`,
      [email]
    );

    console.log('Resultado da busca por usuário:', JSON.stringify(userResult.rows, null, 2));

    if (userResult.rowCount === 0) {
      console.error('Nenhum usuário encontrado para o email:', email);
      client.release();
      return reply.status(401).send({ error: 'Credenciais inválidas' });
    }

    const user = userResult.rows[0];
    console.log('Usuário encontrado no banco:', JSON.stringify(user, null, 2));

    console.log('Validando senha...');
    console.log('Senha fornecida:', password);
    console.log('Hash da senha no banco:', user.password_hash);
    
    const passwordMatch = await bcrypt.compare(password, user.password_hash);
    console.log('Resultado da validação da senha:', passwordMatch);
    
    if (!passwordMatch) {
      console.error('Senha inválida para o usuário:', email);
      client.release();
      return reply.status(401).send({ error: 'Credenciais inválidas' });
    }

    const [
      progress,
      ultimoAcesso,
      simulados,
      analises
    ] = await Promise.all([
      client.query(`SELECT * FROM user_progress WHERE user_id = $1`, [user.id]),
      client.query(`SELECT * FROM user_ultimo_acesso WHERE user_id = $1 ORDER BY data_acesso DESC LIMIT 5`, [user.id]),
      client.query(`SELECT * FROM user_simulados WHERE user_id = $1 ORDER BY created_at DESC`, [user.id]),
      client.query(`SELECT * FROM user_analise_desempenho WHERE user_id = $1 ORDER BY created_at DESC`, [user.id]),
    ]);

    const token = jwt.sign(
      {
        userId: user.id,
        email: user.email,
        userType: user.user_type,
      },
      JWT_SECRET,
      { expiresIn: '12h' }
    );
    
    const responseData = {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        user_type: user.user_type,
        photoUrl: user.photo_url,
        progress: progress.rows[0] || null,
        ultimoAcesso: ultimoAcesso.rows,
        simulados: simulados.rows,
        analiseDesempenho: analises.rows,
      },
    };
    
    client.release();
    
    return reply.status(200).send(responseData);

  } catch (err) {
    console.error('=== ERRO AO PROCESSAR LOGIN ===');
    
    const error = err as Error;
    
    if (error instanceof Error) {
      console.error('Tipo do erro:', error.constructor.name);
      console.error('Mensagem de erro:', error.message);
      
      if ('stack' in error) {
        console.error('Stack trace:', (error as { stack?: string }).stack);
      }
      
      try {
        console.error('Error object:', JSON.stringify(error, Object.getOwnPropertyNames(error)));
      } catch (e) {
        console.error('Não foi possível serializar o objeto de erro');
      }
      
      fastify.log.error('Erro ao processar login:', error);
      
      if (client) {
        client.release();
      }
      
      const response: Record<string, unknown> = { 
        error: 'Erro ao processar login'
      };
      
      if (process.env.NODE_ENV === 'development') {
        response.details = error.message;
      }
      
      return reply.status(500).send(response);
    } else {
      console.error('Erro desconhecido:', String(err));
      
      if (client) {
        client.release();
      }
      
      return reply.status(500).send({ 
        error: 'Erro desconhecido ao processar login'
      });
    }
  }
});
}
