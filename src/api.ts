import type { SignUpRequest, SignInRequest, UserResponse, SignInResponse, ErrorResponse } from './models.ts';

const BASE_URL = 'http://localhost:8040/auth';

export async function signUp(data: SignUpRequest): Promise<UserResponse> {
    const response = await fetch(`${BASE_URL}/signup`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
        credentials: 'include'
    });

    if (!response.ok) {
        const error: ErrorResponse = await response.json();
        throw new Error(error.error);
    }

    return response.json();
}

export async function signIn(data: SignInRequest): Promise<SignInResponse> {
    const response = await fetch(`${BASE_URL}/signin`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
        credentials: 'include'
    });

    if (!response.ok) {
        const error: ErrorResponse = await response.json();
        throw new Error(error.error);
    }

    return response.json();
}

export async function logout(): Promise<{ message: string }> {
    const response = await fetch(`${BASE_URL}/logout`, {
        method: 'POST',
        credentials: 'include'
    });

    if (!response.ok) {
        const error: ErrorResponse = await response.json();
        throw new Error(error.error);
    }

    return response.json();
}