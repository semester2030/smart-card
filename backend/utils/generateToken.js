const jwt = require('jsonwebtoken');

const DEFAULT_EXPIRES_IN = '7d';

const resolveExpiresIn = () => {
  const rawValue = (process.env.JWT_EXPIRE || DEFAULT_EXPIRES_IN).trim();

  if (!rawValue) {
    return DEFAULT_EXPIRES_IN;
  }

  // If it's a pure number, convert to seconds (int)
  if (/^\d+$/.test(rawValue)) {
    return parseInt(rawValue, 10);
  }

  // Accept strings like 10s, 15m, 7d, 1y etc.
  if (/^\d+\s*[smhdwy]$/i.test(rawValue)) {
    return rawValue.replace(/\s+/g, '');
  }

  console.warn(`⚠️  Invalid JWT_EXPIRE value "${rawValue}", falling back to ${DEFAULT_EXPIRES_IN}`);
  return DEFAULT_EXPIRES_IN;
};

const generateToken = (id) => {
  return jwt.sign(
    { id },
    process.env.JWT_SECRET || 'your-secret-key',
    { expiresIn: resolveExpiresIn() }
  );
};

module.exports = generateToken;

