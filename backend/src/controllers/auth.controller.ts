import { FastifyRequest, FastifyReply } from 'fastify';
import { z } from 'zod';
import bcrypt from 'bcrypt';
import prisma from '../config/database';

const registerSchema = z.object({
  name: z.string().min(3),
  email: z.string().email(),
  password: z.string().min(6),
  user_type: z.string().min(3),
  photoUrl: z.string().optional(), 
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});


export const register = async (req: FastifyRequest, reply: FastifyReply) => {
  try {
    const { name, email, password, user_type } = registerSchema.parse(req.body);

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return reply.status(400).send({ message: 'Email already in use' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
        user_type,
      },
    });


    await prisma.userProgress.create({
      data: {
        userId: user.id,
        diasSequencia: 0,
        totalQuestoes: 0,
        acertos: 0,
        mediaGeral: 0,
        diasEstudo: 0,
      },
    });

    await prisma.userUltimoAcesso.create({
      data: {
        userId: user.id,
        titulo: 'Bem-vindo(a)',
        disciplina: 'geral',
        progresso: 0,
        dataAcesso: new Date(),
      },
    });

    await prisma.userSimulado.create({
      data: {
        userId: user.id,
        titulo: 'Simulado Inicial',
        descricao: 'Simulado diagnóstico automático',
        totalQuestoes: 0,
        tempoMinutos: 0,
        isNovo: true,
      },
    });

    await prisma.userAnaliseDesempenho.create({
      data: {
        userId: user.id,
        pontuacaoMedia: 0,
        totalQuestoes: 0,
        acertos: 0,
        disciplina: 'geral',
      },
    });

    const token = req.jwt.sign({
      userId: user.id,
      email: user.email,
      userType: user.user_type,
    });

    return reply.status(201).send({
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        user_type: user.user_type,
      },
      token,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return reply.status(400).send({ message: 'Validation error', errors: error.errors });
    }
    console.error('Registration error:', error);
    return reply.status(500).send({ message: 'Internal server error' });
  }
};


export const login = async (req: FastifyRequest, reply: FastifyReply) => {
  try {
    const { email, password } = loginSchema.parse(req.body);

    const user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
      return reply.status(401).send({ message: 'Invalid credentials' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return reply.status(401).send({ message: 'Invalid credentials' });
    }

    const token = req.jwt.sign({
      userId: user.id,
      email: user.email,
      userType: user.user_type,
    });

    return reply.send({
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        user_type: user.user_type,
        photoUrl: user.photoUrl, 
      },
      token,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return reply.status(400).send({ message: 'Validation error', errors: error.errors });
    }
    console.error('Login error:', error);
    return reply.status(500).send({ message: 'Internal server error' });
  }
};


export const getCurrentUser = async (req: FastifyRequest, reply: FastifyReply) => {
  try {
    const userId = req.user.userId;

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        name: true,
        email: true,
        user_type: true,
        photoUrl: true,
      },
    });

    if (!user) {
      return reply.status(404).send({ message: 'User not found' });
    }

    return reply.send({ user });
  } catch (error) {
    console.error('Get current user error:', error);
    return reply.status(500).send({ message: 'Internal server error' });
  }
};
