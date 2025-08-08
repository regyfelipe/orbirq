import { FastifyInstance } from 'fastify';
import pool from '../config/database';

interface QuestionQueryParams {
  page?: number;
  limit?: number;
  discipline?: string;
  subject?: string;
  year?: number;
  board?: string;
}

export async function userRoutes(fastify: FastifyInstance) {
  fastify.get('/users/:userId/progress', async (request, reply) => {
    const { userId } = request.params as { userId: string };
    const client = await pool.connect();

    try {
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        return reply.status(404).send({ 
          success: false,
          error: 'Usuário não encontrado' 
        });
      }

      const progressResult = await client.query(
        `SELECT 
          COUNT(*) as total_questoes,
          SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) as acertos,
          COALESCE(ROUND(AVG(CASE WHEN is_correct THEN 100.0 ELSE 0 END), 2), 0) as media_geral,
          COUNT(DISTINCT DATE(created_at)) as dias_estudo
        FROM user_responses 
        WHERE user_id = $1`,
        [userId]
      );

      const progress = {
        success: true,
        data: {
          totalQuestoes: parseInt(progressResult.rows[0]?.total_questoes) || 0,
          acertos: parseInt(progressResult.rows[0]?.acertos) || 0,
          mediaGeral: parseFloat(progressResult.rows[0]?.media_geral) || 0,
          diasEstudo: parseInt(progressResult.rows[0]?.dias_estudo) || 0
        }
      };

      return reply.status(200).send(progress);
    } catch (error) {
      console.error('Erro ao buscar progresso do usuário:', error);
      return reply.status(500).send({ error: 'Erro interno do servidor' });
    } finally {
      client.release();
    }
  });

  fastify.get('/users/:userId/ultimos-acessos', async (request, reply) => {
    const { userId } = request.params as { userId: string };
    const client = await pool.connect();

    try {
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        return reply.status(404).send({ error: 'Usuário não encontrado' });
      }

      const ultimosAcessos = [
        {
          id: 1,
          titulo: 'Matemática Básica',
          disciplina: 'Matemática',
          dataAcesso: new Date().toISOString(),
          progresso: 65.0 
        },
        {
          id: 2,
          titulo: 'Português - Verbos',
          disciplina: 'Português',
          dataAcesso: new Date(Date.now() - 86400000).toISOString(),
          progresso: 30.0 
        }
      ];

      return ultimosAcessos;
    } catch (error) {
      console.error('Erro ao buscar últimos acessos:', error);
      return reply.status(500).send({ error: 'Erro interno do servidor' });
    } finally {
      client.release();
    }
  });

  fastify.get('/users/:userId/simulados', async (request, reply) => {
    const { userId } = request.params as { userId: string };
    const client = await pool.connect();

    try {
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        return reply.status(404).send({ error: 'Usuário não encontrado' });
      }

      const simulados = [
        {
          id: 1,
          titulo: 'Simulado ENEM 2023',
          data: new Date().toISOString(),
          pontuacao: 720,
          isNovo: true,
          progresso: 0
        }
      ];

      return simulados;
    } catch (error) {
      console.error('Erro ao buscar simulados:', error);
      return reply.status(500).send({ error: 'Erro interno do servidor' });
    } finally {
      client.release();
    }
  });

  fastify.get('/users/:userId/analises-desempenho', async (request, reply) => {
    const { userId } = request.params as { userId: string };
    const client = await pool.connect();

    try {
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        return reply.status(404).send({ error: 'Usuário não encontrado' });
      }

      return [];
    } catch (error) {
      console.error('Erro ao buscar análises de desempenho:', error);
      return reply.status(500).send({ error: 'Erro interno do servidor' });
    } finally {
      client.release();
    }
  });

  fastify.get<{Querystring: QuestionQueryParams}>('/questions', async (request, reply) => {
    const { 
      page = 1, 
      limit = 10, 
      discipline, 
      subject, 
      year, 
      board 
    } = request.query;

    const client = await pool.connect();
    const offset = (page - 1) * limit;

    try {
      let query = 'SELECT * FROM questions';
      const queryParams: any[] = [];
      const whereClauses: string[] = [];
      let paramIndex = 1;
      if (discipline) {
        whereClauses.push(`discipline ILIKE $${paramIndex}`);
        queryParams.push(`%${discipline}%`);
        paramIndex++;
      }

      if (subject) {
        whereClauses.push(`subject ILIKE $${paramIndex}`);
        queryParams.push(`%${subject}%`);
        paramIndex++;
      }

      if (year) {
        whereClauses.push(`year = $${paramIndex}`);
        queryParams.push(year);
        paramIndex++;
      }

      if (board) {
        whereClauses.push(`board ILIKE $${paramIndex}`);
        queryParams.push(`%${board}%`);
        paramIndex++;
      }

      if (whereClauses.length > 0) {
        query += ' WHERE ' + whereClauses.join(' AND ');
      }
      query += ` ORDER BY id`;
      query += ` LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
      queryParams.push(limit, offset);

      const result = await client.query(query, queryParams);

      let countQuery = 'SELECT COUNT(*) FROM questions';
      if (whereClauses.length > 0) {
        countQuery += ' WHERE ' + whereClauses.join(' AND ');
      }
      const countResult = await client.query(countQuery, queryParams.slice(0, -2));
      const total = parseInt(countResult.rows[0].count, 10);

      const questions = result.rows.map(row => ({
        id: row.id,
        discipline: row.discipline,
        subject: row.subject,
        year: row.year,
        board: row.board,
        exam: row.exam,
        text: row.text,
        supportingText: row.supporting_text,
        imageUrl: row.image_url,
        correctAnswer: row.correct_answer,
        explanation: row.explanation,
        type: row.type,
        options: row.options
      }));

      return {
        data: questions,
        pagination: {
          page,
          limit,
          total,
          totalPages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      console.error('Erro ao buscar questões:', error);
      return reply.status(500).send({ error: 'Erro interno do servidor' });
    } finally {
      client.release();
    }
  });
}
