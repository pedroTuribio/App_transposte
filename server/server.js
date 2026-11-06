const express = require('express');
const cors = require('cors');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Log simples de cada requisição
app.use((req, _res, next) => {
  console.log(`${new Date().toLocaleTimeString()}  ${req.method} ${req.url}`);
  next();
});

// ---------- "Banco de dados" em memória ----------
const hash = (senha) => crypto.createHash('sha256').update(senha).digest('hex');

let nextId = 2;
const users = [
  { id: 1, name: 'Ana Souza', email: 'ana@carteira.dev', passwordHash: hash('123456') },
];
const sessions = new Map(); // token -> userId

// Dados de exemplo (cartão de transporte estudantil)
const balances = new Map([[1, 42.5]]);
const transactionsByUser = new Map([
  [1, [
    { id: 1, type: 'recharge', description: 'Recarga', amount: 50.0, date: '2026-11-01T09:00:00Z' },
    { id: 2, type: 'trip', description: 'Passagem - Linha 101', amount: -2.5, date: '2026-11-03T07:15:00Z' },
    { id: 3, type: 'trip', description: 'Passagem - Linha 101', amount: -2.5, date: '2026-11-03T12:40:00Z' },
    { id: 4, type: 'trip', description: 'Passagem - Linha 205', amount: -2.5, date: '2026-11-04T07:10:00Z' },
  ]],
]);

// ---------- Autenticação ----------
function auth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  const userId = token && sessions.get(token);
  if (!userId) return res.status(401).json({ message: 'Não autorizado' });
  req.user = users.find((u) => u.id === userId);
  req.token = token;
  next();
}

const publicUser = (u) => ({ id: u.id, name: u.name, email: u.email });

function createSession(user) {
  const token = crypto.randomBytes(24).toString('hex');
  sessions.set(token, user.id);
  return token;
}

// ---------- Rotas ----------
app.get('/', (_req, res) => res.json({ status: 'ok', app: 'carteira_server_novo' }));

app.post('/auth/register', (req, res) => {
  const { name, email, password } = req.body || {};
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Informe nome, e-mail e senha' });
  }
  if (users.some((u) => u.email.toLowerCase() === String(email).toLowerCase())) {
    return res.status(409).json({ message: 'E-mail já cadastrado' });
  }
  const user = { id: nextId++, name, email, passwordHash: hash(password) };
  users.push(user);
  balances.set(user.id, 0);
  transactionsByUser.set(user.id, []);
  const token = createSession(user);
  res.status(201).json({ token, user: publicUser(user) });
});

app.post('/auth/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = users.find(
    (u) => u.email.toLowerCase() === String(email || '').toLowerCase()
  );
  if (!user || user.passwordHash !== hash(String(password || ''))) {
    return res.status(401).json({ message: 'E-mail ou senha inválidos' });
  }
  const token = createSession(user);
  res.json({ token, user: publicUser(user) });
});

app.post('/auth/logout', auth, (req, res) => {
  sessions.delete(req.token);
  res.json({ ok: true });
});

app.get('/me', auth, (req, res) => {
  res.json(publicUser(req.user));
});

app.get('/summary', auth, (req, res) => {
  const list = transactionsByUser.get(req.user.id) || [];
  const trips = list.filter((t) => t.type === 'trip');
  const lastRecharge = list.filter((t) => t.type === 'recharge').pop();
  res.json({
    balance: { amount: balances.get(req.user.id) || 0, currency: 'BRL' },
    tripsCount: trips.length,
    totalSpent: Math.abs(trips.reduce((s, t) => s + t.amount, 0)),
    lastRecharge: lastRecharge || null,
  });
});

app.get('/transactions', auth, (req, res) => {
  const list = [...(transactionsByUser.get(req.user.id) || [])].reverse();
  res.json(list);
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
  console.log('Usuário de teste: ana@carteira.dev  /  senha: 123456');
});
