<script lang="ts">
    import { onMount } from 'svelte';
    import type { SignUpRequest, SignInRequest } from './models';
    import { signUp, signIn, logout } from './api';

    let activeTab: 'signin' | 'signup' = 'signin';
    let username = '';
    let email = '';
    let password = '';
    let confirmPassword = '';
    let errorMessage = '';
    let successMessage = '';
    let isLoading = false;

    // Для хранения состояния авторизации
    let isAuthenticated = false;

    // Проверяем состояние аутентификации при монтировании
    onMount(async () => {
        // Здесь можно добавить проверку токена, если он доступен
        // Но так как токен в HttpOnly cookie, мы не можем его прочитать напрямую
        // Можно сделать запрос к /user/me чтобы проверить аутентификацию
    });

    function switchTab(tab: 'signin' | 'signup') {
        activeTab = tab;
        resetForm();
    }

    function resetForm() {
        username = '';
        email = '';
        password = '';
        confirmPassword = '';
        errorMessage = '';
        successMessage = '';
    }

    async function handleSignUp() {
        errorMessage = '';
        successMessage = '';
        isLoading = true;

        try {
            if (password !== confirmPassword) {
                throw new Error('Пароли не совпадают');
            }

            const data: SignUpRequest = {
                username,
                email,
                password
            };

            const response = await signUp(data);
            successMessage = 'Регистрация прошла успешно!';
            switchTab('signin');
        } catch (err) {
            errorMessage = err instanceof Error ? err.message : 'Произошла ошибка при регистрации';
        } finally {
            isLoading = false;
        }
    }

    async function handleSignIn() {
        errorMessage = '';
        successMessage = '';
        isLoading = true;

        try {
            const data: SignInRequest = {
                email,
                password
            };

            const response = await signIn(data);
            successMessage = 'Вход выполнен успешно!';
            isAuthenticated = true;
        } catch (err) {
            errorMessage = err instanceof Error ? err.message : 'Произошла ошибка при входе';
        } finally {
            isLoading = false;
        }
    }

    async function handleSignOut() {
        try {
            await logout();
            isAuthenticated = false;
            successMessage = 'Вы вышли из системы';
        } catch (err) {
            errorMessage = err instanceof Error ? err.message : 'Произошла ошибка при выходе';
        }
    }

    function validateEmail(email: string): boolean {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    function validatePassword(password: string): boolean {
        return password.length >= 6;
    }

    $: isFormValid = activeTab === 'signin'
        ? validateEmail(email) && validatePassword(password)
        : validateEmail(email) && validatePassword(password) && password === confirmPassword && username.trim() !== '';
</script>

<div class="auth-container">
    {#if isAuthenticated}
        <div class="authenticated-view">
            <h2>Вы вошли в систему</h2>
            <p>Добро пожаловать!</p>
            <button on:click={handleSignOut} class="btn btn-secondary">Выйти</button>
        </div>
    {:else}
        <div class="auth-form">
            <div class="tabs">
                <button
                    class={`tab-btn ${activeTab === 'signin' ? 'active' : ''}`}
                    on:click={() => switchTab('signin')}
                >
                    Вход
                </button>
                <button
                    class={`tab-btn ${activeTab === 'signup' ? 'active' : ''}`}
                    on:click={() => switchTab('signup')}
                >
                    Регистрация
                </button>
            </div>

            {#if activeTab === 'signin'}
                <form on:submit|preventDefault={handleSignIn} class="form">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input
                            type="email"
                            id="email"
                            bind:value={email}
                            required
                            placeholder="your@email.com"
                        />
                    </div>

                    <div class="form-group">
                        <label for="password">Пароль:</label>
                        <input
                            type="password"
                            id="password"
                            bind:value={password}
                            required
                            minlength="6"
                            placeholder="••••••"
                        />
                    </div>

                    <button
                        type="submit"
                        disabled={!isFormValid || isLoading}
                        class="btn btn-primary"
                    >
                        {isLoading ? 'Вход...' : 'Войти'}
                    </button>
                </form>
            {:else}
                <form on:submit|preventDefault={handleSignUp} class="form">
                    <div class="form-group">
                        <label for="username">Имя пользователя:</label>
                        <input
                            type="text"
                            id="username"
                            bind:value={username}
                            required
                            minlength="3"
                            placeholder="Имя пользователя"
                        />
                    </div>

                    <div class="form-group">
                        <label for="signup-email">Email:</label>
                        <input
                            type="email"
                            id="signup-email"
                            bind:value={email}
                            required
                            placeholder="your@email.com"
                        />
                    </div>

                    <div class="form-group">
                        <label for="signup-password">Пароль:</label>
                        <input
                            type="password"
                            id="signup-password"
                            bind:value={password}
                            required
                            minlength="6"
                            placeholder="••••••"
                        />
                    </div>

                    <div class="form-group">
                        <label for="confirm-password">Подтвердите пароль:</label>
                        <input
                            type="password"
                            id="confirm-password"
                            bind:value={confirmPassword}
                            required
                            placeholder="••••••"
                        />
                    </div>

                    <button
                        type="submit"
                        disabled={!isFormValid || isLoading}
                        class="btn btn-primary"
                    >
                        {isLoading ? 'Регистрация...' : 'Зарегистрироваться'}
                    </button>
                </form>
            {/if}

            {#if errorMessage}
                <div class="error-message">{errorMessage}</div>
            {/if}

            {#if successMessage}
                <div class="success-message">{successMessage}</div>
            {/if}
        </div>
    {/if}
</div>

<style>
    .auth-container {
        max-width: 400px;
        margin: 0 auto;
        padding: 2rem;
        font-family: Arial, sans-serif;
    }

    .tabs {
        display: flex;
        border-bottom: 1px solid #ddd;
        margin-bottom: 1.5rem;
    }

    .tab-btn {
        padding: 0.75rem 1.5rem;
        border: 1px solid #ddd;
        background: #f5f5f5;
        cursor: pointer;
        border-radius: 0.25rem 0.25rem 0 0;
        margin-right: 0.25rem;
    }

    .tab-btn.active {
        background: #fff;
        border-bottom: 1px solid #fff;
        margin-bottom: -1px;
        font-weight: bold;
    }

    .form-group {
        margin-bottom: 1rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.25rem;
        font-weight: bold;
    }

    .form-group input {
        width: 100%;
        padding: 0.5rem;
        border: 1px solid #ccc;
        border-radius: 0.25rem;
        box-sizing: border-box;
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 0.25rem;
        cursor: pointer;
        font-size: 1rem;
        width: 100%;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:disabled {
        background-color: #cccccc;
        cursor: not-allowed;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .error-message {
        color: #dc3545;
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        padding: 0.75rem;
        border-radius: 0.25rem;
        margin-top: 1rem;
    }

    .success-message {
        color: #155724;
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        padding: 0.75rem;
        border-radius: 0.25rem;
        margin-top: 1rem;
    }

    .authenticated-view {
        text-align: center;
    }

    .authenticated-view h2 {
        margin-bottom: 1rem;
    }

    .authenticated-view p {
        margin-bottom: 1.5rem;
    }
</style>