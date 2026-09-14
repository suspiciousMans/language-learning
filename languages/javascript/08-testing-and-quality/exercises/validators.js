// validators.js - Validation module
export const isEmail = (email) => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
};

export const isPhoneNumber = (phone) => {
  return /^\d{10}$/.test(phone.replace(/\D/g, ''));
};

export const isStrongPassword = (password) => {
  return password.length >= 8 && /[A-Z]/.test(password) && /[0-9]/.test(password);
};
