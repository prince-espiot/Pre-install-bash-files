FROM node:22.2-bookworm
RUN apt update && \
    apt install -y curl ca-certificates postgresql-common && \
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt update && \
    apt install -y postgresql-client-16 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json package-lock.json ./
COPY internal/db/migrations ./migrations
COPY scripts/migrate.sh .
RUN npm ci && chmod +x ./migrate.sh
ENTRYPOINT ["./migrate.sh"]
