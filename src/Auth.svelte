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
    let isAuthenticated = false;

    // --- Логика смены темы ---
    let isDarkMode = false;

    onMount(async () => {
        // Проверяем сохраненную тему или настройки системы
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            isDarkMode = true;
            document.documentElement.setAttribute('data-theme', 'dark');
        } else {
            document.documentElement.setAttribute('data-theme', 'light');
        }
    });

    function toggleTheme() {
        isDarkMode = !isDarkMode;
        const theme = isDarkMode ? 'dark' : 'light';
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
    }
    // -------------------------

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

            const data: SignUpRequest = { username, email, password };
            await signUp(data);
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
            const data: SignInRequest = { email, password };
            await signIn(data);
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

<div class="auth-wrapper">
    <div class="theme-toggle-container">
        <button class="theme-btn" on:click={toggleTheme} aria-label="Сменить тему">
            {isDarkMode ? '☀️ Светлая' : '🌙 Темная'}
        </button>
    </div>

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
                            <input type="email" id="email" bind:value={email} required placeholder="your@email.com" />
                        </div>

                        <div class="form-group">
                            <label for="password">Пароль:</label>
                            <input type="password" id="password" bind:value={password} required minlength="6" placeholder="••••••" />
                        </div>

                        <button type="submit" disabled={!isFormValid || isLoading} class="btn btn-primary">
                            {isLoading ? 'Вход...' : 'Войти'}
                        </button>
                    </form>
                {:else}
                    <form on:submit|preventDefault={handleSignUp} class="form">
                        <div class="form-group">
                            <label for="username">Имя пользователя:</label>
                            <input type="text" id="username" bind:value={username} required minlength="3" placeholder="Имя пользователя" />
                        </div>

                        <div class="form-group">
                            <label for="signup-email">Email:</label>
                            <input type="email" id="signup-email" bind:value={email} required placeholder="your@email.com" />
                        </div>

                        <div class="form-group">
                            <label for="signup-password">Пароль:</label>
                            <input type="password" id="signup-password" bind:value={password} required minlength="6" placeholder="••••••" />
                        </div>

                        <div class="form-group">
                            <label for="confirm-password">Подтвердите пароль:</label>
                            <input type="password" id="confirm-password" bind:value={confirmPassword} required placeholder="••••••" />
                        </div>

                        <button type="submit" disabled={!isFormValid || isLoading} class="btn btn-primary">
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
</div>

<style>
    /* Обертка для центрирования кнопки и формы */
    .auth-wrapper {
        width: 100%;
        max-width: 480px; /* Растянули до 480px */
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    /* Стили кнопки смены темы */
    .theme-toggle-container {
        display: flex;
        justify-content: flex-end;
    }

    .theme-btn {
        background: var(--surface-color);
        border: 1px solid var(--border-color);
        color: var(--text-color);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .theme-btn:hover {
        border-color: var(--primary-color);
        color: var(--primary-color);
    }

    /* Основной контейнер формы */
    .auth-container {
        background-color: var(--surface-color);
        border: 1px solid var(--border-color);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        border-radius: 12px;
        padding: 2.5rem;
        font-family: inherit;
        color: var(--text-color);
    }

    /* Вкладки */
    .tabs {
        display: flex;
        border-bottom: 2px solid var(--border-color);
        margin-bottom: 2rem;
    }

    .tab-btn {
        flex: 1; /* Вкладки делят ширину пополам */
        padding: 1rem;
        border: none;
        background: transparent;
        color: var(--text-muted);
        cursor: pointer;
        font-weight: 600;
        font-size: 1.1rem;
        transition: all 0.2s;
        border-bottom: 2px solid transparent;
        margin-bottom: -2px;
    }

    .tab-btn:hover {
        color: var(--text-color);
    }

    .tab-btn.active {
        color: var(--primary-color);
        border-bottom: 2px solid var(--primary-color);
    }

    /* Форма и инпуты */
    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 600;
        font-size: 0.9rem;
        color: var(--text-color);
    }

    .form-group input {
        width: 100%;
        padding: 0.875rem;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        box-sizing: border-box;
        background-color: var(--input-bg);
        color: var(--text-color);
        font-size: 1rem;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-group input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
    }

    /* Кнопки */
    .btn {
        padding: 1rem;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 1.1rem;
        font-weight: 600;
        width: 100%; /* Растягиваем на всю ширину */
        transition: all 0.2s;
        text-align: center;
    }

    .btn-primary {
        background-color: var(--primary-color);
        color: #ffffff; /* Белый текст на первичной кнопке всегда */
        box-shadow: 0 4px 6px rgba(79, 70, 229, 0.2);
    }

    .btn-primary:hover:not(:disabled) {
        background-color: var(--primary-hover);
        transform: translateY(-1px);
    }

    .btn-primary:disabled {
        background-color: var(--border-color);
        color: var(--text-muted);
        cursor: not-allowed;
        box-shadow: none;
    }

    .btn-secondary {
        background-color: transparent;
        border: 1px solid var(--border-color);
        color: var(--text-color);
    }

    .btn-secondary:hover {
        background-color: var(--error-bg);
        color: var(--error-text);
        border-color: var(--error-border);
    }

    /* Уведомления */
    .error-message, .success-message {
        padding: 1rem;
        border-radius: 8px;
        margin-top: 1.5rem;
        font-weight: 500;
        text-align: center;
    }

    .error-message {
        color: var(--error-text);
        background-color: var(--error-bg);
        border: 1px solid var(--error-border);
    }

    .success-message {
        color: var(--success-text);
        background-color: var(--success-bg);
        border: 1px solid var(--success-border);
    }

    .authenticated-view {
        text-align: center;
        padding: 2rem 0;
    }

    .authenticated-view h2 {
        margin-bottom: 1rem;
        color: var(--text-color);
    }

    .authenticated-view p {
        margin-bottom: 2rem;
        color: var(--text-muted);
    }
</style>