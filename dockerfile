# 1️⃣ Base image — slim, modern Linux
FROM python:3.10-slim

# 2️⃣ Install utilities
RUN apt-get update && apt-get install -y \
    wget curl unzip git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 3️⃣ Install Weaviate
RUN wget https://github.com/weaviate/weaviate/releases/latest/download/weaviate-linux-amd64.tar.gz \
 && tar -xzf weaviate-linux-amd64.tar.gz -C /usr/local/bin \
 && rm weaviate-linux-amd64.tar.gz

# 4️⃣ Install required Python packages (for model servers)
RUN pip install --no-cache-dir \
    flask \
    transformers \
    torch \
    sentence-transformers \
    gunicorn

# 5️⃣ Copy the startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 6️⃣ Expose ports — 8080 for Weaviate, 8081–8083 for models
EXPOSE 8080 8081 8082 8083

# 7️⃣ Run the startup script
CMD ["/bin/bash", "/app/start.sh"]
