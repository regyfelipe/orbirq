import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config(); 

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: Number(process.env.DB_PORT) || 5432,
});

async function testConnection() {
  try {
    const client = await pool.connect();
    console.log('Conexão com PostgreSQL estabelecida com sucesso!');
    client.release();
  } catch (error) {
    console.error('Erro na conexão com PostgreSQL:', error);
  }
}

testConnection();

export default pool;
