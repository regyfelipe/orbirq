-- Create user_responses table
CREATE TABLE IF NOT EXISTS user_responses (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question_id VARCHAR(255) NOT NULL,
  question_text TEXT NOT NULL,
  user_answer VARCHAR(255) NOT NULL,
  correct_answer VARCHAR(255) NOT NULL,
  is_correct BOOLEAN NOT NULL,
  subject VARCHAR(100) NOT NULL,
  topic VARCHAR(100),
  difficulty VARCHAR(50),
  time_spent_seconds INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_user_responses_user_id ON user_responses(user_id);
CREATE INDEX IF NOT EXISTS idx_user_responses_question_id ON user_responses(question_id);
CREATE INDEX IF NOT EXISTS idx_user_responses_created_at ON user_responses(created_at);
CREATE INDEX IF NOT EXISTS idx_user_responses_subject ON user_responses(subject);
CREATE INDEX IF NOT EXISTS idx_user_responses_is_correct ON user_responses(is_correct);
