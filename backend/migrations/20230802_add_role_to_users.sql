-- Adiciona a coluna role se não existir
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'student';

-- Cria o índice se não existir
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
