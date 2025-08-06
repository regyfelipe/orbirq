import { FastifyRequest, FastifyReply } from 'fastify';
import { z } from 'zod';
import bcrypt from 'bcrypt';
import prisma from '../config/database';

const registerSchema = z.object({
  name: z.string().min(3),
  email: z.string().email(),
  password: z.string().min(6),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

export const register = async (req: FastifyRequest, reply: FastifyReply) => {
  try {
    const { name, email, password } = registerSchema.parse(req.body);
    
    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return reply.status(400).send({ message: 'Email already in use' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const user = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    });

    // Generate JWT token
    const token = req.jwt.sign({ userId: user.id });

    return reply.status(201).send({
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
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

    // Find user
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return reply.status(401).send({ message: 'Invalid credentials' });
    }

    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return reply.status(401).send({ message: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = req.jwt.sign({ userId: user.id });

    return reply.send({
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
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
        // Add other fields you want to return
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
