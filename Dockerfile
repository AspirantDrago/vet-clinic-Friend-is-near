# ---------- 1) BUILD: Vue ----------
FROM node:22-alpine3.22 AS front-build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

ENV NODE_ENV=production

RUN npm run build

# ---------- 2) PROD: Python + nginx ----------
FROM python:3.12-alpine AS prod

WORKDIR /app

RUN apk add --no-cache nginx

COPY backend/requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /usr/share/nginx/html

COPY --from=front-build /app/dist /usr/share/nginx/html

RUN rm -f /etc/nginx/conf.d/* /etc/nginx/http.d/*
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf

COPY docker/start.sh /start.sh

RUN chmod +x /start.sh

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

COPY backend/ ./

EXPOSE 8080

CMD ["/start.sh"]
