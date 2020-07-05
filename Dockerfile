FROM node:alpine as builder
WORKDIR /usr/src/app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY --from=builder /usr/src/app/dist/angular-app /usr/share/nginx/html


