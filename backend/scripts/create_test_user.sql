-- Script para criar um usuário de teste
-- Senha: teste123
INSERT INTO users (name, email, password_hash, user_type, created_at, updated_at)
VALUES (
  'Usuário Teste', 
  'teste@teste.com', 
  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- senha: teste123
  'aluno',
  NOW(),
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- Inserir dados de progresso para o usuário de teste
INSERT INTO user_progress (user_id, total_questions, correct_answers, last_updated)
SELECT id, 100, 75, NOW()
FROM users
WHERE email = 'teste@teste.com'
ON CONFLICT (user_id) DO NOTHING;

-- Inserir último acesso
INSERT INTO user_ultimo_acesso (user_id, titulo, disciplina, data_acesso)
SELECT id, 'Matemática Básica', 'Matemática', NOW()
FROM users
WHERE email = 'teste@teste.com';

-- Inserir simulado
INSERT INTO user_simulados (user_id, titulo, data_realizacao, nota, total_questoes, acertos)
SELECT id, 'Simulado 1', NOW(), 7.5, 10, 8
FROM users
WHERE email = 'teste@teste.com';

-- Inserir análise de desempenho
INSERT INTO user_analise_desempenho (user_id, disciplina, percentual_acerto, data_analise)
SELECT id, 'Matemática', 75.0, NOW()
FROM users
WHERE email = 'teste@teste.com';
