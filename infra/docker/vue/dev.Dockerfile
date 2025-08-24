FROM node:lts-alpine

WORKDIR /app

COPY ./app-vue/package*.json ./
RUN npm install

COPY ./app-vue .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]