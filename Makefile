# Makefile для управления Svelte + TypeScript проектом
# Использование: make [команда]

# ==========================================
# ПЕРЕМЕННЫЕ КОНФИГУРАЦИИ
# ==========================================

# Имя проекта
PROJECT_NAME := svelte-counter-app

# Основные директории
SRC_DIR := src
DIST_DIR := dist
NODE_MODULES := node_modules

# Цвета для вывода (для Linux/macOS)
ifneq (,$(findstring cygwin,$(shell uname -o 2>/dev/null)))
    # Windows (Cygwin) - отключаем цвета
    COLOR_RESET :=
    COLOR_INFO :=
    COLOR_SUCCESS :=
    COLOR_ERROR :=
    COLOR_WARNING :=
else ifneq (,$(findstring Linux,$(shell uname 2>/dev/null)))
    # Linux - включаем цвета
    COLOR_RESET := \033[0m
    COLOR_INFO := \033[36m
    COLOR_SUCCESS := \033[32m
    COLOR_ERROR := \033[31m
    COLOR_WARNING := \033[33m
else ifneq (,$(findstring Darwin,$(shell uname 2>/dev/null)))
    # macOS - включаем цвета
    COLOR_RESET := \033[0m
    COLOR_INFO := \033[36m
    COLOR_SUCCESS := \033[32m
    COLOR_ERROR := \033[31m
    COLOR_WARNING := \033[33m
else
    # Windows или другая система - отключаем цвета
    COLOR_RESET :=
    COLOR_INFO :=
    COLOR_SUCCESS :=
    COLOR_ERROR :=
    COLOR_WARNING :=
endif

# Команды NPM
NPM := npm
NPM_RUN := $(NPM) run

# ==========================================
# ЦЕЛИ ПО УМОЛЧАНИЮ
# ==========================================

.PHONY: help
help: ## Показать это сообщение с подсказкой
	@echo "$(COLOR_INFO)Доступные команды для управления проектом $(PROJECT_NAME):$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_SUCCESS)УСТАНОВКА И НАСТРОЙКА:$(COLOR_RESET)"
	@echo "  make install        - Установить все зависимости"
	@echo "  make reinstall      - Переустановить все зависимости (удалить node_modules и установить заново)"
	@echo ""
	@echo "$(COLOR_SUCCESS)ЗАПУСК:$(COLOR_RESET)"
	@echo "  make dev           - Запустить проект в режиме разработки"
	@echo "  make start         - Алиас для make dev"
	@echo "  make preview       - Запустить предпросмотр собранного проекта"
	@echo ""
	@echo "$(COLOR_SUCCESS)СБОРКА:$(COLOR_RESET)"
	@echo "  make build         - Собрать проект для продакшена"
	@echo "  make build-dev     - Собрать проект в режиме разработки"
	@echo "  make build-watch   - Собрать проект и следить за изменениями"
	@echo "  make clean         - Очистить папку сборки (dist)"
	@echo ""
	@echo "$(COLOR_SUCCESS)ПРОВЕРКА КАЧЕСТВА:$(COLOR_RESET)"
	@echo "  make lint          - Запустить линтер (проверка кода)"
	@echo "  make lint-fix      - Запустить линтер и исправить ошибки"
	@echo "  make format        - Отформатировать код с помощью Prettier"
	@echo "  make check         - Проверить типы TypeScript"
	@echo "  make validate      - Запустить все проверки (lint + check)"
	@echo ""
	@echo "$(COLOR_SUCCESS)ТЕСТИРОВАНИЕ:$(COLOR_RESET)"
	@echo "  make test          - Запустить тесты (если настроены)"
	@echo "  make test-watch    - Запустить тесты в режиме наблюдения"
	@echo "  make test-coverage - Запустить тесты с покрытием кода"
	@echo ""
	@echo "$(COLOR_SUCCESS)УПРАВЛЕНИЕ:$(COLOR_RESET)"
	@echo "  make stop          - Остановить все процессы (найти и завершить процесс dev)"
	@echo "  make restart       - Перезапустить проект (stop + dev)"
	@echo "  make status        - Показать статус проекта"
	@echo "  make info          - Показать информацию о проекте"
	@echo ""
	@echo "$(COLOR_SUCCESS)ОБСЛУЖИВАНИЕ:$(COLOR_RESET)"
	@echo "  make update        - Обновить все зависимости"
	@echo "  make outdated      - Показать устаревшие пакеты"
	@echo "  make audit         - Проверить безопасность зависимостей"
	@echo "  make audit-fix     - Исправить проблемы безопасности"
	@echo ""
	@echo "$(COLOR_SUCCESS)ОЧИСТКА:$(COLOR_RESET)"
	@echo "  make clean-all     - Полная очистка (dist + node_modules)"
	@echo "  make clean-cache   - Очистить кэш"
	@echo ""
	@echo "$(COLOR_SUCCESS)DOCKER (если используется):$(COLOR_RESET)"
	@echo "  make docker-build  - Собрать Docker образ"
	@echo "  make docker-run    - Запустить Docker контейнер"
	@echo "  make docker-stop   - Остановить Docker контейнер"
	@echo ""
	@echo "$(COLOR_WARNING)Для получения подробной информации о команде используйте: make help-[команда]$(COLOR_RESET)"

# ==========================================
# УСТАНОВКА И НАСТРОЙКА
# ==========================================

.PHONY: install
install: ## Установить все зависимости
	@echo "$(COLOR_INFO)📦 Установка зависимостей...$(COLOR_RESET)"
	@$(NPM) install
	@echo "$(COLOR_SUCCESS)✅ Зависимости успешно установлены$(COLOR_RESET)"

.PHONY: reinstall
reinstall: clean-all install ## Переустановить все зависимости
	@echo "$(COLOR_SUCCESS)✅ Проект переустановлен$(COLOR_RESET)"

# ==========================================
# ЗАПУСК
# ==========================================

.PHONY: dev start
dev start: ## Запустить проект в режиме разработки
	@echo "$(COLOR_INFO)🚀 Запуск проекта в режиме разработки...$(COLOR_RESET)"
	@echo "$(COLOR_INFO)📡 Сервер будет доступен по адресу: http://localhost:5173$(COLOR_RESET)"
	@$(NPM_RUN) dev

.PHONY: preview
preview: ## Запустить предпросмотр собранного проекта
	@echo "$(COLOR_INFO)👁️  Запуск предпросмотра собранного проекта...$(COLOR_RESET)"
	@$(NPM_RUN) preview

# ==========================================
# СБОРКА
# ==========================================

.PHONY: build
build: clean ## Собрать проект для продакшена
	@echo "$(COLOR_INFO)🏗️  Сборка проекта для продакшена...$(COLOR_RESET)"
	@$(NPM_RUN) build
	@echo "$(COLOR_SUCCESS)✅ Проект собран в папку $(DIST_DIR)/$(COLOR_RESET)"

.PHONY: build-dev
build-dev: ## Собрать проект в режиме разработки
	@echo "$(COLOR_INFO)🔧 Сборка проекта в режиме разработки...$(COLOR_RESET)"
	@$(NPM) run build -- --mode development

.PHONY: build-watch
build-watch: ## Собрать проект и следить за изменениями
	@echo "$(COLOR_INFO)👀 Сборка проекта в режиме наблюдения...$(COLOR_RESET)"
	@$(NPM) run build -- --watch

.PHONY: clean
clean: ## Очистить папку сборки (dist)
	@echo "$(COLOR_INFO)🧹 Очистка папки $(DIST_DIR)/...$(COLOR_RESET)"
	@rm -rf $(DIST_DIR)
	@mkdir -p $(DIST_DIR)
	@echo "$(COLOR_SUCCESS)✅ Папка $(DIST_DIR)/ очищена$(COLOR_RESET)"

# ==========================================
# ПРОВЕРКА КАЧЕСТВА
# ==========================================

.PHONY: lint
lint: ## Запустить линтер
	@echo "$(COLOR_INFO)🔍 Запуск линтера...$(COLOR_RESET)"
	@$(NPM_RUN) lint 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Линтер не настроен. Установите eslint: npm install eslint --save-dev$(COLOR_RESET)"

.PHONY: lint-fix
lint-fix: ## Запустить линтер и исправить ошибки
	@echo "$(COLOR_INFO)🔧 Исправление ошибок линтера...$(COLOR_RESET)"
	@$(NPM_RUN) lint -- --fix 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Линтер не настроен$(COLOR_RESET)"

.PHONY: format
format: ## Отформатировать код с помощью Prettier
	@echo "$(COLOR_INFO)✨ Форматирование кода...$(COLOR_RESET)"
	@npx prettier --write "$(SRC_DIR)/**/*.{js,ts,svelte}" 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Prettier не установлен. Установите: npm install prettier --save-dev$(COLOR_RESET)"

.PHONY: check
check: ## Проверить типы TypeScript
	@echo "$(COLOR_INFO)🔍 Проверка типов TypeScript...$(COLOR_RESET)"
	@npx tsc --noEmit
	@echo "$(COLOR_SUCCESS)✅ Типы проверены успешно$(COLOR_RESET)"

.PHONY: validate
validate: lint check ## Запустить все проверки
	@echo "$(COLOR_SUCCESS)✅ Все проверки пройдены$(COLOR_RESET)"

# ==========================================
# ТЕСТИРОВАНИЕ
# ==========================================

.PHONY: test
test: ## Запустить тесты
	@echo "$(COLOR_INFO)🧪 Запуск тестов...$(COLOR_RESET)"
	@$(NPM_RUN) test 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Тесты не настроены. Установите vitest: npm install vitest --save-dev$(COLOR_RESET)"

.PHONY: test-watch
test-watch: ## Запустить тесты в режиме наблюдения
	@echo "$(COLOR_INFO)👀 Запуск тестов в режиме наблюдения...$(COLOR_RESET)"
	@$(NPM_RUN) test -- --watch 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Тесты не настроены$(COLOR_RESET)"

.PHONY: test-coverage
test-coverage: ## Запустить тесты с покрытием кода
	@echo "$(COLOR_INFO)📊 Запуск тестов с покрытием...$(COLOR_RESET)"
	@$(NPM_RUN) test -- --coverage 2>/dev/null || echo "$(COLOR_WARNING)⚠️  Тесты не настроены$(COLOR_RESET)"

# ==========================================
# УПРАВЛЕНИЕ ПРОЦЕССАМИ
# ==========================================

.PHONY: stop
stop: ## Остановить все процессы (найти и завершить процесс dev)
	@echo "$(COLOR_INFO)🛑 Остановка процессов...$(COLOR_RESET)"
	@-pkill -f "vite" 2>/dev/null || true
	@-lsof -ti:5173 | xargs kill -9 2>/dev/null || true
	@echo "$(COLOR_SUCCESS)✅ Процессы остановлены$(COLOR_RESET)"

.PHONY: restart
restart: stop dev ## Перезапустить проект

.PHONY: status
status: ## Показать статус проекта
	@echo "$(COLOR_INFO)📊 Статус проекта:$(COLOR_RESET)"
	@echo ""
	@echo "Проверка запущенных процессов:"
	@-ps aux | grep -E "vite|node" | grep -v grep || echo "  Нет запущенных процессов"
	@echo ""
	@echo "Проверка порта 5173:"
	@-lsof -i:5173 || echo "  Порт 5173 свободен"
	@echo ""
	@echo "Проверка директорий:"
	@if [ -d "$(DIST_DIR)" ]; then echo "  ✅ Папка $(DIST_DIR) существует"; else echo "  ❌ Папка $(DIST_DIR) не найдена"; fi
	@if [ -d "$(NODE_MODULES)" ]; then echo "  ✅ Папка $(NODE_MODULES) существует"; else echo "  ❌ Папка $(NODE_MODULES) не найдена"; fi

.PHONY: info
info: ## Показать информацию о проекте
	@echo "$(COLOR_INFO)ℹ️  Информация о проекте:$(COLOR_RESET)"
	@echo ""
	@echo "Имя проекта: $(PROJECT_NAME)"
	@echo "Node версия: $(shell node -v 2>/dev/null || echo 'Node не установлен')"
	@echo "NPM версия: $(shell npm -v 2>/dev/null || echo 'NPM не установлен')"
	@echo ""
	@echo "Директории:"
	@echo "  Исходный код: $(SRC_DIR)/"
	@echo "  Сборка: $(DIST_DIR)/"
	@echo ""
	@echo "Зависимости:"
	@echo "  Всего: $(shell cat package.json | grep -c '"dependencies"' 2>/dev/null || echo '0')"
	@echo "  Dev: $(shell cat package.json | grep -c '"devDependencies"' 2>/dev/null || echo '0')"

# ==========================================
# ОБСЛУЖИВАНИЕ ЗАВИСИМОСТЕЙ
# ==========================================

.PHONY: update
update: ## Обновить все зависимости
	@echo "$(COLOR_INFO)🔄 Обновление зависимостей...$(COLOR_RESET)"
	@$(NPM) update
	@echo "$(COLOR_SUCCESS)✅ Зависимости обновлены$(COLOR_RESET)"

.PHONY: outdated
outdated: ## Показать устаревшие пакеты
	@echo "$(COLOR_INFO)📋 Проверка устаревших пакетов...$(COLOR_RESET)"
	@$(NPM) outdated

.PHONY: audit
audit: ## Проверить безопасность зависимостей
	@echo "$(COLOR_INFO)🔒 Проверка безопасности...$(COLOR_RESET)"
	@$(NPM) audit

.PHONY: audit-fix
audit-fix: ## Исправить проблемы безопасности
	@echo "$(COLOR_INFO)🔧 Исправление проблем безопасности...$(COLOR_RESET)"
	@$(NPM) audit fix

# ==========================================
# ПОЛНАЯ ОЧИСТКА
# ==========================================

.PHONY: clean-all
clean-all: clean ## Полная очистка (dist + node_modules)
	@echo "$(COLOR_INFO)🗑️  Полная очистка проекта...$(COLOR_RESET)"
	@rm -rf $(NODE_MODULES)
	@rm -f package-lock.json
	@echo "$(COLOR_SUCCESS)✅ Проект полностью очищен$(COLOR_RESET)"

.PHONY: clean-cache
clean-cache: ## Очистить кэш
	@echo "$(COLOR_INFO)🧹 Очистка кэша...$(COLOR_RESET)"
	@$(NPM) cache clean --force
	@rm -rf .svelte-kit 2>/dev/null || true
	@rm -rf .vite 2>/dev/null || true
	@echo "$(COLOR_SUCCESS)✅ Кэш очищен$(COLOR_RESET)"

# ==========================================
# DOCKER КОМАНДЫ (опционально)
# ==========================================

.PHONY: docker-build
docker-build: ## Собрать Docker образ
	@echo "$(COLOR_INFO)🐳 Сборка Docker образа...$(COLOR_RESET)"
	@docker build -t $(PROJECT_NAME) .

.PHONY: docker-run
docker-run: ## Запустить Docker контейнер
	@echo "$(COLOR_INFO)🐳 Запуск Docker контейнера...$(COLOR_RESET)"
	@docker run -d -p 5173:5173 --name $(PROJECT_NAME) $(PROJECT_NAME)
	@echo "$(COLOR_SUCCESS)✅ Контейнер запущен на порту 5173$(COLOR_RESET)"

.PHONY: docker-stop
docker-stop: ## Остановить Docker контейнер
	@echo "$(COLOR_INFO)🐳 Остановка Docker контейнера...$(COLOR_RESET)"
	@docker stop $(PROJECT_NAME) 2>/dev/null || true
	@docker rm $(PROJECT_NAME) 2>/dev/null || true
	@echo "$(COLOR_SUCCESS)✅ Контейнер остановлен$(COLOR_RESET)"

# ==========================================
# ДОПОЛНИТЕЛЬНЫЕ КОМАНДЫ
# ==========================================

.PHONY: create-component
create-component: ## Создать новый компонент: make create-component name=MyComponent
	@if [ -z "$(name)" ]; then \
		echo "$(COLOR_ERROR)❌ Ошибка: укажите имя компонента (make create-component name=MyComponent)$(COLOR_RESET)"; \
		exit 1; \
	fi
	@mkdir -p $(SRC_DIR)/components
	@echo "<script lang=\"ts\">\n  export let name: string = '$(name)';\n</script>\n\n<div>\n  <h1>Компонент {name}</h1>\n</div>\n\n<style>\n  div {\n    padding: 1rem;\n  }\n</style>" > $(SRC_DIR)/components/$(name).svelte
	@echo "$(COLOR_SUCCESS)✅ Компонент $(name).svelte создан в $(SRC_DIR)/components/$(COLOR_RESET)"

.PHONY: backup
backup: ## Создать бэкап проекта
	@echo "$(COLOR_INFO)💾 Создание бэкапа...$(COLOR_RESET)"
	@tar -czf ../$(PROJECT_NAME)-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz --exclude=node_modules --exclude=dist .
	@echo "$(COLOR_SUCCESS)✅ Бэкап создан$(COLOR_RESET)"

# ==========================================
# HELPER КОМАНДЫ
# ==========================================

.PHONY: help-install
help-install: ## Подробная информация об установке
	@echo "$(COLOR_INFO)📦 Установка проекта:$(COLOR_RESET)"
	@echo "  1. make install     - установить зависимости"
	@echo "  2. make dev         - запустить разработку"
	@echo ""
	@echo "Если возникают проблемы:"
	@echo "  make reinstall      - переустановить все зависимости"
	@echo "  make clean-cache    - очистить кэш"

.PHONY: help-dev
help-dev: ## Подробная информация о разработке
	@echo "$(COLOR_INFO)🚀 Режим разработки:$(COLOR_RESET)"
	@echo "  Команда: make dev"
	@echo "  Порт: 5173"
	@echo "  Особенности:"
	@echo "    - Горячая перезагрузка"
	@echo "    - Проверка типов в реальном времени"
	@echo "    - Source maps для отладки"

# Добавляем цель по умолчанию
.DEFAULT_GOAL := help