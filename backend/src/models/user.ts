export interface User {
  id?: number;
  name: string;
  email: string;
  passwordHash: string; // armazene a senha com hash, nunca plain text
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
