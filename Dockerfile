FROM node:22-alpine3.22

WORKDIR /app

RUN apk add --no-cache 'python3~3.12' py3-pip

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 8080 5000

CMD ["sh", "-c", "python3 main.py & npm run serve"]
