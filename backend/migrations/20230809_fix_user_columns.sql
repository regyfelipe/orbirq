-- Renomeia a coluna role para user_type se ela existir
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'users' AND column_name = 'role') THEN
        ALTER TABLE users RENAME COLUMN role TO user_type;
    END IF;
END $$;

-- Adiciona a coluna photo_url se não existir
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS photo_url TEXT;

-- Atualiza o índice para usar user_type em vez de role
DROP INDEX IF EXISTS idx_users_role;
CREATE INDEX IF NOT EXISTS idx_users_user_type ON users(user_type);
