<script lang="ts">
    import { onMount } from 'svelte';
    import { locale, t } from './i18n';
    import { signUp, signIn, logout } from './api';

    let activeTab: 'signin' | 'signup' = 'signin';
    let username = '', email = '', password = '', confirmPassword = '';
    let errorMessage = '', successMessage = '', isLoading = false;
    let isAuthenticated = false;
    let isDarkMode = false;

    onMount(() => {
        const savedTheme = localStorage.getItem('theme');
        isDarkMode = savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches);
        document.documentElement.setAttribute('data-theme', isDarkMode ? 'dark' : 'light');
        
        const savedLang = localStorage.getItem('lang') as 'ru' | 'en';
        if (savedLang) locale.set(savedLang);
    });

    function toggleTheme() {
        isDarkMode = !isDarkMode;
        const theme = isDarkMode ? 'dark' : 'light';
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
    }

    function toggleLang() {
        locale.update(l => {
            const newLang = l === 'ru' ? 'en' : 'ru';
            localStorage.setItem('lang', newLang);
            return newLang;
        });
    }

    // Вспомогательная функция для смены табов
    function setTab(tab: 'signin' | 'signup') {
        activeTab = tab;
        errorMessage = ''; successMessage = '';
    }

    async function handleAuth(type: 'login' | 'register') {
        errorMessage = ''; successMessage = ''; isLoading = true;
        try {
            if (type === 'register') {
                if (password !== confirmPassword) throw new Error($t('errPasswordMismatch'));
                await signUp({ username, email, password });
                successMessage = $t('succSignUp');
                setTimeout(() => setTab('signin'), 1500);
            } else {
                await signIn({ email, password });
                isAuthenticated = true;
                successMessage = $t('succSignIn');
            }
        } catch (err) {
            errorMessage = err instanceof Error ? err.message : 'Error';
        } finally { isLoading = false; }
    }

    $: isFormValid = activeTab === 'signin' 
        ? (email && password.length >= 6)
        : (username && email && password.length >= 6 && password === confirmPassword);
</script>

<div class="auth-wrapper">
    <div class="top-bar">
        <button class="icon-btn" on:click={toggleLang}>
            🌍 <span class="btn-text">{$locale.toUpperCase()}</span>
        </button>
        <button class="icon-btn" on:click={toggleTheme}>
            {isDarkMode ? $t('themeLight') : $t('themeDark')}
        </button>
    </div>

    <div class="card">
        {#if isAuthenticated}
            <div class="status-view">
                <div class="success-icon">✓</div>
                <h2>{$t('authTitle')}</h2>
                <p>{$t('authWelcome')}</p>
                <button class="btn btn-secondary" on:click={() => isAuthenticated = false}>
                    {$t('btnLogout')}
                </button>
            </div>
        {:else}
            <div class="tabs">
                <button class="tab" class:active={activeTab === 'signin'} on:click={() => setTab('signin')}>
                    {$t('tabSignIn')}
                </button>
                <button class="tab" class:active={activeTab === 'signup'} on:click={() => setTab('signup')}>
                    {$t('tabSignUp')}
                </button>
            </div>

            <form on:submit|preventDefault={() => handleAuth(activeTab === 'signin' ? 'login' : 'register')}>
                {#if activeTab === 'signup'}
                    <div class="field">
                        <label for="u">{$t('labelUsername')}</label>
                        <input id="u" type="text" bind:value={username} placeholder={$t('phUsername')} />
                    </div>
                {/if}

                <div class="field">
                    <label for="e">{$t('labelEmail')}</label>
                    <input id="e" type="email" bind:value={email} placeholder="mail@example.com" />
                </div>

                <div class="field">
                    <label for="p">{$t('labelPassword')}</label>
                    <input id="p" type="password" bind:value={password} placeholder="••••••" />
                </div>

                {#if activeTab === 'signup'}
                    <div class="field">
                        <label for="cp">{$t('labelConfirm')}</label>
                        <input id="cp" type="password" bind:value={confirmPassword} placeholder="••••••" />
                    </div>
                {/if}

                <button type="submit" class="btn btn-primary" disabled={!isFormValid || isLoading}>
                    {isLoading ? $t(activeTab === 'signin' ? 'btnSigningIn' : 'btnSigningUp') : $t(activeTab === 'signin' ? 'btnSignIn' : 'btnSignUp')}
                </button>
            </form>

            {#if errorMessage}<div class="msg err">{errorMessage}</div>{/if}
            {#if successMessage}<div class="msg succ">{successMessage}</div>{/if}
        {/if}
    </div>
</div>

<style>
    .auth-wrapper {
        width: 100%;
        max-width: 420px;
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .top-bar {
        display: flex;
        justify-content: flex-end;
        gap: 0.75rem;
    }

    .icon-btn {
        background: var(--surface-color);
        border: 1px solid var(--border-color);
        color: var(--text-color);
        padding: 0.5rem 0.8rem;
        border-radius: 12px;
        cursor: pointer;
        font-size: 0.85rem;
        display: flex;
        align-items: center;
        gap: 0.4rem;
        transition: all 0.2s;
    }

    .icon-btn:hover {
        border-color: var(--primary-color);
        transform: translateY(-1px);
    }

    .card {
        background: var(--surface-color);
        padding: 2.5rem;
        border-radius: 24px;
        border: 1px solid var(--border-color);
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    .tabs {
        display: flex;
        background: var(--bg-color);
        padding: 0.3rem;
        border-radius: 14px;
        margin-bottom: 2rem;
    }

    .tab {
        flex: 1;
        padding: 0.7rem;
        border: none;
        background: transparent;
        color: var(--text-muted);
        cursor: pointer;
        font-weight: 600;
        border-radius: 10px;
        transition: all 0.2s;
    }

    .tab.active {
        background: var(--surface-color);
        color: var(--primary-color);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    .field {
        margin-bottom: 1.25rem;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    label {
        font-size: 0.85rem;
        font-weight: 600;
        color: var(--text-muted);
        margin-left: 0.2rem;
    }

    input {
        width: 100%;
        padding: 0.8rem 1rem;
        border-radius: 12px;
        border: 1px solid var(--border-color);
        background: var(--input-bg);
        color: var(--text-color);
        font-size: 1rem;
        outline: none;
        transition: all 0.2s;
    }

    input:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
    }

    .btn {
        width: 100%;
        padding: 1rem;
        border-radius: 12px;
        font-weight: 700;
        cursor: pointer;
        border: none;
        transition: all 0.2s;
        margin-top: 1rem;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
    }

    .btn-primary:hover:not(:disabled) {
        background: var(--primary-hover);
        transform: translateY(-1px);
    }

    .btn-primary:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .btn-secondary {
        background: transparent;
        border: 1px solid var(--border-color);
        color: var(--text-color);
    }

    .msg {
        margin-top: 1.5rem;
        padding: 0.8rem;
        border-radius: 10px;
        text-align: center;
        font-size: 0.9rem;
        font-weight: 500;
    }

    .err { background: var(--error-bg); color: var(--error-text); border: 1px solid var(--error-border); }
    .succ { background: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); }

    .status-view {
        text-align: center;
    }

    .success-icon {
        width: 60px;
        height: 60px;
        background: var(--success-bg);
        color: var(--success-text);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        margin: 0 auto 1.5rem;
    }
</style>