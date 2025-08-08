import { FastifyInstance } from 'fastify';
import pool from '../config/database';

interface SaveResponseBody {
  userId: number;
  questionId: string;
  questionText: string;
  userAnswer: string;
  correctAnswer: string;
  isCorrect: boolean;
  subject: string;
  topic?: string;
  difficulty?: string;
  timeSpentSeconds?: number;
}

export async function responseRoutes(fastify: FastifyInstance) {
  fastify.get('/responses', async (request, reply) => {
    const client = await pool.connect();
    
    try {
      const result = await client.query(
        `SELECT 
          id,
          user_id as "userId",
          question_id as "questionId",
          question_text as "questionText",
          user_answer as "userAnswer",
          correct_answer as "correctAnswer",
          is_correct as "isCorrect",
          subject,
          topic,
          difficulty,
          time_spent_seconds as "timeSpentSeconds",
          created_at as "createdAt"
        FROM user_responses
        ORDER BY created_at DESC`
      );
      
      return {
        success: true,
        data: result.rows
      };
    } catch (error) {
      console.error('Error fetching responses:', error);
      return reply.status(500).send({ 
        success: false,
        error: 'Error fetching responses',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    } finally {
      client.release();
    }
  });

  fastify.post<{ Body: SaveResponseBody }>('/responses', async (request, reply) => {
    const {
      userId,
      questionId,
      questionText,
      userAnswer,
      correctAnswer,
      isCorrect,
      subject,
      topic: requestTopic,
      difficulty,
      timeSpentSeconds,
    } = request.body;

    const client = await pool.connect();

    try {
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        return reply.status(404).send({ error: 'User not found' });
      }

      let topic = requestTopic;
      if (!topic && questionId) {
        try {
          const questionResult = await client.query(
            'SELECT topic FROM questions WHERE id = $1',
            [questionId]
          );
          if (questionResult.rows.length > 0) {
            topic = questionResult.rows[0].topic || null;
          }
        } catch (error) {
          console.error('Error fetching question topic:', error);
        }
      }
      console.log('[Save Response] Saving response for user:', userId, 'question:', questionId);
      
      const result = await client.query(
        `INSERT INTO user_responses (
          user_id, question_id, question_text, user_answer, 
          correct_answer, is_correct, subject, topic, difficulty, time_spent_seconds
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING id, user_id as "userId", question_id as "questionId"`,
        [
          userId,
          questionId,
          questionText,
          userAnswer,
          correctAnswer,
          isCorrect,
          subject,
          topic || null,
          difficulty || null,
          timeSpentSeconds || null,
        ]
      );

      await client.query(
        `UPDATE user_progress 
        SET 
          total_questoes = total_questoes + 1,
          acertos = acertos + $1,
          media_geral = (
            SELECT AVG(CASE WHEN is_correct THEN 1.0 ELSE 0.0 END) * 100 
            FROM user_responses 
            WHERE user_id = $2
          )
        WHERE user_id = $2`,
        [isCorrect ? 1 : 0, userId]
      );

      console.log('[Save Response] Successfully saved response for user:', userId);
      
      const countResult = await client.query(
        'SELECT COUNT(*) as total FROM user_responses WHERE user_id = $1',
        [userId]
      );
      
      return { 
        success: true, 
        message: 'Response saved successfully',
        data: {
          id: result.rows[0].id,
          userId: result.rows[0].userId,
          questionId: result.rows[0].questionId,
          totalResponses: parseInt(countResult.rows[0].total, 10)
        }
      };
    } catch (error) {
      console.error('Error saving response:', error);
      return reply.status(500).send({ 
        error: 'Error saving response',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    } finally {
      client.release();
    }
  });

  fastify.get<{ Params: { userId: string } }>('/users/:userId/performance', async (request, reply) => {
    const { userId } = request.params;
    const client = await pool.connect();

    try {
      console.log(`[Performance] Starting performance fetch for user ${userId}`);
      
      const userResult = await client.query(
        'SELECT id FROM users WHERE id = $1',
        [userId]
      );

      if (userResult.rowCount === 0) {
        console.log(`[Performance] User ${userId} not found`);
        return reply.status(404).send({ error: 'User not found' });
      }

      let bySubject = [];
      try {
        const result = await client.query(
          `WITH subject_totals AS (
            SELECT 
              ur.subject,
              COALESCE(q.topic, '') as topic,
              COUNT(*) as total_responses,
              COALESCE(SUM(CASE WHEN ur.is_correct = true THEN 1 ELSE 0 END), 0) as correct_responses
            FROM user_responses ur
            LEFT JOIN questions q ON ur.question_id = q.id::text
            WHERE ur.user_id = $1
            GROUP BY ur.subject, q.topic
          )
          SELECT 
            subject,
            jsonb_object_agg(
              CASE 
                WHEN topic IS NULL OR topic = '' OR topic = 'Geral' THEN 'Geral'
                ELSE topic
              END,
              jsonb_build_object(
                'total_responses', total_responses,
                'correct_responses', correct_responses,
                'accuracy', CASE WHEN total_responses > 0 
                  THEN ROUND((correct_responses::numeric / total_responses) * 100, 2)
                  ELSE 0 
                END
              )
            ) as topics
          FROM subject_totals
          GROUP BY subject`,
          [userId]
        );
        
        bySubject = result.rows.map(row => {
          const topics = row.topics || {};
          const topicEntries = Object.entries(topics);
          
          interface TopicStats {
            total_responses?: number;
            correct_responses?: number;
          }
          
          const total_responses = topicEntries.reduce<number>(
            (sum, [_, topicData]) => sum + ((topicData as TopicStats).total_responses || 0), 0
          );
          
          const correct_responses = topicEntries.reduce<number>(
            (sum, [_, topicData]) => sum + ((topicData as TopicStats).correct_responses || 0), 0
          );
          
          return {
            subject: row.subject,
            total_responses,
            correct_responses,
            calculated_accuracy: total_responses > 0 
              ? parseFloat(((correct_responses / total_responses) * 100).toFixed(2))
              : 0,
            topics: topics
          };
        });
        
        console.log(`[Performance] Found ${bySubject.length} subjects with responses`);
      } catch (error) {
        console.error('[Performance] Error fetching by subject:', error);
        const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
        throw new Error(`Error fetching by subject: ${errorMessage}`);
      }

      let recentResponses = [];
      try {
        const result = await client.query(
          `SELECT 
            id, 
            question_text as question_text, 
            is_correct, 
            subject, 
            created_at 
          FROM user_responses 
          WHERE user_id = $1 
          ORDER BY created_at DESC 
          LIMIT 10`,
          [userId]
        );
        recentResponses = result.rows;
      } catch (error) {
        console.error('[Performance] Error fetching recent responses:', error);
      }

      let byDifficulty = [];
      try {
        const result = await client.query(
          `SELECT 
            difficulty,
            COUNT(*) as total,
            ROUND(COALESCE(AVG(CASE WHEN is_correct THEN 1.0 ELSE 0.0) * 100, 0), 2) as accuracy
          FROM user_responses 
          WHERE user_id = $1 
            AND difficulty IS NOT NULL 
          GROUP BY difficulty`,
          [userId]
        );
        byDifficulty = result.rows;
      } catch (error) {
        console.error('[Performance] Error fetching by difficulty:', error);
      }

      const totalResponses = bySubject.reduce((sum, row) => {
        const value = row.total_responses;
        return sum + (typeof value === 'string' ? parseInt(value, 10) || 0 : Number(value) || 0);
      }, 0);
      const correctResponses = bySubject.reduce((sum, row) => {
        const value = row.correct_responses;
        return sum + (typeof value === 'string' ? parseInt(value, 10) || 0 : Number(value) || 0);
      }, 0);
      const accuracy = totalResponses > 0 ? Math.round((correctResponses / totalResponses) * 100) : 0;

      const processedBySubject = bySubject.map(subject => ({
        ...subject,
        total_responses: typeof subject.total_responses === 'string' 
          ? parseInt(subject.total_responses) || 0 
          : Number(subject.total_responses) || 0,
        correct_responses: typeof subject.correct_responses === 'string'
          ? parseInt(subject.correct_responses) || 0
          : Number(subject.correct_responses) || 0
      }));

      const processedByDifficulty = byDifficulty.map(difficulty => ({
        ...difficulty,
        total: parseInt(difficulty.total) || 0,
        accuracy: parseFloat(difficulty.accuracy) || 0
      }));

      const processedRecentResponses = recentResponses.map(response => ({
        ...response,
        is_correct: Boolean(response.is_correct)
      }));

      const response = {
        success: true,
        data: {
          bySubject: processedBySubject,
          recentResponses: processedRecentResponses,
          byDifficulty: processedByDifficulty,
          totalResponses: Number(totalResponses) || 0,
          correctResponses: Number(correctResponses) || 0,
          accuracy: Number(accuracy) || 0,
          totalSubjects: Number(bySubject.length) || 0
        }
      };

      const sanitizedResponse = {
        ...response.data,
        bySubject: processedBySubject.map(s => ({
          ...s,
          calculated_accuracy: s.total_responses > 0
            ? parseFloat(((s.correct_responses / s.total_responses) * 100).toFixed(2))
            : 0.0,
        })),
      };
      
      return reply.send({
        success: true,
        data: sanitizedResponse
      });

      console.log(`[Performance] Successfully fetched data for user ${userId}`);
      return reply.send(response);
      
    } catch (error) {
      console.error('[Performance] Error in performance endpoint:', error);
      return reply.status(500).send({ 
        error: 'Error fetching performance data',
        details: error instanceof Error ? error.message : 'Unknown error',
        stack: process.env.NODE_ENV === 'development' ? error instanceof Error ? error.stack : undefined : undefined
      });
    } finally {
      client.release();
    }
  });
}
