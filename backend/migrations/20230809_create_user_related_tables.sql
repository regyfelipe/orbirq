-- Tabela de progresso do usuário
CREATE TABLE IF NOT EXISTS user_progress (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_questions INTEGER NOT NULL DEFAULT 0,
  correct_answers INTEGER NOT NULL DEFAULT 0,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Tabela de último acesso
CREATE TABLE IF NOT EXISTS user_ultimo_acesso (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  titulo VARCHAR(100) NOT NULL,
  disciplina VARCHAR(50) NOT NULL,
  data_acesso TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Tabela de simulados
CREATE TABLE IF NOT EXISTS user_simulados (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  titulo VARCHAR(100) NOT NULL,
  data_realizacao TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  nota NUMERIC(5,2) NOT NULL,
  total_questoes INTEGER NOT NULL,
  acertos INTEGER NOT NULL
);

-- Tabela de análise de desempenho
CREATE TABLE IF NOT EXISTS user_analise_desempenho (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  disciplina VARCHAR(50) NOT NULL,
  percentual_acerto NUMERIC(5,2) NOT NULL,
  data_analise TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Índices para melhorar o desempenho
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_ultimo_acesso_user_id ON user_ultimo_acesso(user_id);
CREATE INDEX IF NOT EXISTS idx_simulados_user_id ON user_simulados(user_id);
CREATE INDEX IF NOT EXISTS idx_analise_desempenho_user_id ON user_analise_desempenho(user_id);
