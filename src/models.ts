// Запрос на регистрацию
export interface SignUpRequest {
    username: string;
    email:    string;
    password: string;
}

// Запрос на логин
export interface SignInRequest {
    email:    string;
    password: string;
}

// Ответ с данными пользователя (из функции ToResponse)
export interface UserResponse {
    id:         string;
    username:   string;
    email:      string;
    created_at: string; // Формат: "02.01.2006 15:04:05"
    updated_at: string;
}

// Стандартный ответ с ошибкой
export interface ErrorResponse {
    error: string;
}

// Ответ при успешном логине (если токен отдается в JSON)
export interface SignInResponse {
    token?: string; // Опционально, если ты передаешь его только в HttpOnly Cookie
    message?: string;
}