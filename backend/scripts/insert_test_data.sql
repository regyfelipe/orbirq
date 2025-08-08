-- Garantir que a restrição de unicidade em user_id exista
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'user_progress_user_id_key') THEN
    ALTER TABLE user_progress ADD CONSTRAINT user_progress_user_id_key UNIQUE (user_id);
  END IF;
END $$;

-- Inserir dados de progresso para o usuário de teste
INSERT INTO user_progress (user_id, dias_sequencia, total_questoes, acertos, media_geral, dias_estudo, created_at, updated_at)
VALUES 
(3, 5, 100, 75, 75.0, 10, NOW(), NOW())
ON CONFLICT (user_id) DO UPDATE SET
  dias_sequencia = EXCLUDED.dias_sequencia,
  total_questoes = EXCLUDED.total_questoes,
  acertos = EXCLUDED.acertos,
  media_geral = EXCLUDED.media_geral,
  dias_estudo = EXCLUDED.dias_estudo,
  updated_at = NOW();

-- Inserir últimos acessos
INSERT INTO user_ultimo_acesso (user_id, titulo, disciplina, data_acesso)
SELECT 
  3, 
  CASE 
    WHEN n = 1 THEN 'Matemática Básica'
    WHEN n = 2 THEN 'Português - Verbos'
    WHEN n = 3 THEN 'Direito Constitucional'
    WHEN n = 4 THEN 'Informática'
    ELSE 'Raciocínio Lógico'
  END as titulo,
  CASE 
    WHEN n = 1 THEN 'Matemática'
    WHEN n = 2 THEN 'Português'
    WHEN n = 3 THEN 'Direito'
    WHEN n = 4 THEN 'Informática'
    ELSE 'Raciocínio Lógico'
  END as disciplina,
  NOW() - (n || ' days')::interval as data_acesso
FROM generate_series(1, 5) as n
ON CONFLICT DO NOTHING;

-- Inserir simulados
INSERT INTO user_simulados (user_id, titulo, descricao, total_questoes, tempo_minutos, is_novo, created_at, updated_at)
VALUES 
(3, 'Simulado 1 - Básico', 'Simulado básico de conhecimentos gerais', 10, 60, false, NOW() - INTERVAL '5 days', NOW()),
(3, 'Simulado 2 - Intermediário', 'Simulado intermediário para teste de conhecimentos', 10, 60, false, NOW() - INTERVAL '3 days', NOW())
ON CONFLICT DO NOTHING;

-- Inserir análises de desempenho
INSERT INTO user_analise_desempenho (user_id, pontuacao_media, total_questoes, acertos, disciplina, created_at, updated_at)
VALUES 
(3, 75.0, 100, 75, 'Matemática', NOW(), NOW()),
(3, 80.0, 50, 40, 'Português', NOW(), NOW()),
(3, 85.0, 40, 34, 'Direito', NOW(), NOW()),
(3, 90.0, 30, 27, 'Informática', NOW(), NOW())
ON CONFLICT DO NOTHING;
