
export interface User {
  id?: number;
  name: string;
  email: string;
  passwordHash: string;
  userType: 'aluno' | 'professor';
  cpf?: string;
  phone?: string;
  institution?: string;
  registrationNumber?: string;
  course?: string;
  photoUrl?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface UserProgress {
  id?: number;
  userId: number;
  diasSequencia: number;
  totalQuestoes: number;
  acertos: number;
  mediaGeral: number;
  diasEstudo: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface UserUltimoAcesso {
  id?: number;
  userId: number;
  titulo: string;
  disciplina?: string;
  dataAcesso?: Date;
  progresso: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface UserSimulado {
  id?: number;
  userId: number;
  titulo: string;
  descricao?: string;
  totalQuestoes: number;
  tempoMinutos: number;
  isNovo?: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface UserAnaliseDesempenho {
  id?: number;
  userId: number;
  pontuacaoMedia: number;
  totalQuestoes: number;
  acertos: number;
  disciplina: string;
  createdAt?: Date;
  updatedAt?: Date;
}
