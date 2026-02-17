// src/i18n.ts
import { writable, derived } from 'svelte/store';

// 1. Наш словарь с переводами
const translations = {
    ru: {
        // Табы
        tabSignIn: 'Вход',
        tabSignUp: 'Регистрация',
        
        // Форма
        labelEmail: 'Email:',
        labelPassword: 'Пароль:',
        labelUsername: 'Имя пользователя:',
        labelConfirm: 'Подтвердите пароль:',
        
        // Плейсхолдеры
        phUsername: 'Имя пользователя',
        
        // Кнопки
        btnSignIn: 'Войти',
        btnSigningIn: 'Вход...',
        btnSignUp: 'Зарегистрироваться',
        btnSigningUp: 'Регистрация...',
        btnLogout: 'Выйти',
        
        // Сообщения
        errPasswordMismatch: 'Пароли не совпадают',
        errSignUp: 'Произошла ошибка при регистрации',
        errSignIn: 'Произошла ошибка при входе',
        errLogout: 'Произошла ошибка при выходе',
        succSignUp: 'Регистрация прошла успешно!',
        succSignIn: 'Вход выполнен успешно!',
        succLogout: 'Вы вышли из системы',
        
        // Авторизованный вид
        authTitle: 'Вы вошли в систему',
        authWelcome: 'Добро пожаловать!',
        
        // Темы
        themeLight: '☀️ Светлая',
        themeDark: '🌙 Темная'
    },
    en: {
        tabSignIn: 'Sign In',
        tabSignUp: 'Sign Up',
        
        labelEmail: 'Email:',
        labelPassword: 'Password:',
        labelUsername: 'Username:',
        labelConfirm: 'Confirm Password:',
        
        phUsername: 'Username',
        
        btnSignIn: 'Sign In',
        btnSigningIn: 'Signing in...',
        btnSignUp: 'Sign Up',
        btnSigningUp: 'Signing up...',
        btnLogout: 'Log Out',
        
        errPasswordMismatch: 'Passwords do not match',
        errSignUp: 'An error occurred during registration',
        errSignIn: 'An error occurred during sign in',
        errLogout: 'An error occurred during logout',
        succSignUp: 'Registration successful!',
        succSignIn: 'Sign in successful!',
        succLogout: 'You have been logged out',
        
        authTitle: 'You are logged in',
        authWelcome: 'Welcome back!',
        
        themeLight: '☀️ Light',
        themeDark: '🌙 Dark'
    }
};

type Locale = keyof typeof translations;

// 2. Создаем хранилище для текущего языка (по умолчанию 'ru')
export const locale = writable<Locale>('ru');

// 3. Создаем производное хранилище - функцию перевода $t
export const t = derived(locale, ($locale) => {
    return (key: keyof typeof translations['ru']) => {
        return translations[$locale][key] || key;
    };
});