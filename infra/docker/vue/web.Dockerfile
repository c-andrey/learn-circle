# Etapa 1 - Builder (constrói o projeto)
FROM node:lts-alpine AS builder

# Define diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependência primeiro (aproveita cache de build)
COPY ./app-vue/package*.json ./

# Instala dependências sem arquivos extras
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copia todo o código para dentro da imagem
COPY ./app-vue .

# Roda os testes (Vitest) para garantir que a imagem só vai buildar se os testes passarem
RUN npm run test:unit


# Faz o build do projeto (gera dist/)
RUN npm run build


# Etapa 2 - Runtime (imagem final leve, só com os arquivos prontos)
FROM nginx:1.27-alpine

# Copia o build do Vue para a pasta padrão do Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copia configuração customizada do nginx (opcional, se quiser SPA fallback)
# COPY infra/docker/nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta padrão do Nginx
EXPOSE 80

# Comando padrão do container
CMD ["nginx", "-g", "daemon off;"]
