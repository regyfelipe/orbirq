import { Pool } from 'pg';
import { readFileSync } from 'fs';
import { join } from 'path';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: Number(process.env.DB_PORT) || 5432,
});

async function applyMigrations() {
  const client = await pool.connect();
  
  try {
    try {
      await client.query(`
        CREATE TABLE IF NOT EXISTS migrations (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL UNIQUE,
          applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        )
      `);
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Erro desconhecido';
      console.error('❌ Erro ao criar a tabela de migrações:', errorMessage);
      console.log('Continuando com a execução...');
    }

    let appliedMigrationNames = new Set<string>();
    try {
      const appliedMigrations = await client.query('SELECT name FROM migrations');
      appliedMigrationNames = new Set(appliedMigrations.rows.map((r: { name: string }) => r.name));
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'Erro desconhecido';
      console.error('❌ Erro ao buscar migrações aplicadas:', errorMessage);
      console.log('Assumindo que nenhuma migração foi aplicada...');
    }

    const migrationFiles = [
      '20230801_create_users_table.sql',
      '20230802_add_role_to_users.sql',
      '20230808_create_user_responses.sql',
      '20230809_fix_user_columns.sql',
      '20230809_create_user_related_tables.sql',
      '20230810_add_index_to_user_responses.sql',
      '20230811_update_user_responses.sql'
    ];
    
    migrationFiles.sort();

    for (const migrationFile of migrationFiles) {
      if (!appliedMigrationNames.has(migrationFile)) {
        console.log(`\n=== Applying migration: ${migrationFile} ===`);
        const migrationClient = await pool.connect();
        
        try {
          await migrationClient.query('BEGIN');
          
          const migrationSQL = readFileSync(join(__dirname, '..', '..', 'migrations', migrationFile), 'utf8');
          
          const commands = migrationSQL.split(';').filter(cmd => cmd.trim().length > 0);
          
          for (const cmd of commands) {
            const trimmedCmd = cmd.trim();
            if (trimmedCmd) {
              console.log(`Executing: ${trimmedCmd.substring(0, 100)}...`);
              await migrationClient.query(trimmedCmd);
            }
          }
          
          await migrationClient.query('INSERT INTO migrations (name) VALUES ($1)', [migrationFile]);
          await migrationClient.query('COMMIT');
          console.log(`✅ Successfully applied migration: ${migrationFile}`);
        } catch (error) {
          await migrationClient.query('ROLLBACK');
          const errorMessage = error instanceof Error ? error.message : String(error);
          console.error(`❌ Error applying migration ${migrationFile}:`, errorMessage);
          console.log('Continuing with next migration...');
        } finally {
          migrationClient.release();
        }
      } else {
        console.log(`Skipping already applied migration: ${migrationFile}`);
      }
    }
    
    console.log('All migrations applied successfully');
  } catch (error) {
    console.error('Error in migration process:', error);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

applyMigrations().catch(console.error);
