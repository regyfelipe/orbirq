import { FastifyPluginAsync } from 'fastify';
import pool from '../config/database';

const questionRoutes: FastifyPluginAsync = async (fastify, options) => {
  fastify.get('/questions', async (request, reply) => {
    const query = request.query as {
      page?: string;
      limit?: string;
      discipline?: string;
      subject?: string;
      year?: string;
      board?: string;
    };

    const client = await pool.connect();

    try {
      const page = parseInt(query.page || '1');
      const limit = parseInt(query.limit || '10');
      const offset = (page - 1) * limit;
      
      let whereClauses = [];
      const queryParams: any[] = [];
      let paramIndex = 1;

      if (query.discipline) {
        whereClauses.push(`discipline = $${paramIndex++}`);
        queryParams.push(query.discipline);
      }
      
      if (query.subject) {
        whereClauses.push(`subject = $${paramIndex++}`);
        queryParams.push(query.subject);
      }
      
      if (query.year) {
        whereClauses.push(`year = $${paramIndex++}`);
        queryParams.push(parseInt(query.year));
      }
      
      if (query.board) {
        whereClauses.push(`board = $${paramIndex++}`);
        queryParams.push(query.board);
      }

      const whereClause = whereClauses.length > 0 
        ? `WHERE ${whereClauses.join(' AND ')}` 
        : '';
      const questionsQuery = `
        WITH question_options_agg AS (
          SELECT 
            question_id,
            jsonb_agg(
              jsonb_build_object(
                'letter', letter,
                'text', text
              )
              ORDER BY letter
            ) as options_array
          FROM question_options
          GROUP BY question_id
        )
        SELECT 
          q.id, 
          q.discipline, 
          q.subject, 
          q.year, 
          q.board, 
          q.exam, 
          q.text, 
          q.supporting_text as "supportingText",
          q.image_url as "imageUrl",
          COALESCE(o.options_array, '[]'::jsonb) as options,
          q.correct_answer as "correctAnswer",
          q.explanation,
          q.type
        FROM questions q
        LEFT JOIN question_options_agg o ON q.id = o.question_id
        ${whereClause}
        ORDER BY q.id
        LIMIT $${paramIndex++} OFFSET $${paramIndex++}
      `;

      const countQuery = `
        SELECT COUNT(*) 
        FROM questions
        ${whereClause}
      `;

      queryParams.push(limit, offset);
      
      const questionsResult = await client.query(questionsQuery, queryParams);
      
      const countResult = await client.query(countQuery, queryParams.slice(0, -2));
      const total = parseInt(countResult.rows[0].count);
      const totalPages = Math.ceil(total / limit);

      const questions = questionsResult.rows.map(row => ({
        id: row.id,
        discipline: row.discipline,
        subject: row.subject,
        year: row.year,
        board: row.board,
        exam: row.exam,
        text: row.text,
        supportingText: row.supportingText,
        imageUrl: row.imageUrl,
        options: row.options,
        correctAnswer: row.correctAnswer,
        explanation: row.explanation,
        type: row.type
      }));

      return {
        data: questions,
        pagination: {
          page,
          limit,
          total,
          totalPages
        }
      };
    } catch (error: unknown) {
      if (error instanceof Error) {
        console.error('Mensagem:', error.message);
        console.error('Stack:', error.stack);
        
        if (error.message.includes('relation "questions" does not exist')) {
          return reply.status(500).send({ 
            success: false,
            error: 'Tabela de questões não encontrada no banco de dados',
            details: error.message
          });
        }
        
        return reply.status(500).send({ 
          success: false,
          error: 'Erro interno do servidor ao buscar questões',
          details: error.message
        });
      }
      
      return reply.status(500).send({
        success: false,
        error: 'Erro desconhecido ao buscar questões',
        details: String(error)
      });
    } finally {
      client.release();
    }
  });

  fastify.get('/questions/:id', async (request, reply) => {
    const { id } = request.params as { id: string };
    const client = await pool.connect();

    try {
      const result = await client.query(
        `
        WITH question_options_agg AS (
          SELECT 
            question_id,
            jsonb_agg(
              jsonb_build_object(
                'letter', letter,
                'text', text
              )
              ORDER BY letter
            ) as options_array
          FROM question_options
          WHERE question_id = $1
          GROUP BY question_id
        )
        SELECT 
          q.id, 
          q.discipline, 
          q.subject, 
          q.year, 
          q.board, 
          q.exam, 
          q.text, 
          q.supporting_text as "supportingText",
          q.image_url as "imageUrl",
          COALESCE(o.options_array, '[]'::jsonb) as options,
          q.correct_answer as "correctAnswer",
          q.explanation,
          q.type
        FROM questions q
        LEFT JOIN question_options_agg o ON q.id = o.question_id
        WHERE q.id = $1
        `,
        [id]
      );

      if (result.rows.length === 0) {
        return reply.status(404).send({ 
          success: false,
          error: 'Questão não encontrada' 
        });
      }

      return {
        success: true,
        data: result.rows[0]
      };
    } catch (error) {
      return reply.status(500).send({ 
        success: false,
        error: 'Erro interno do servidor' 
      });
    } finally {
      client.release();
    }
  });
};

export default questionRoutes;
