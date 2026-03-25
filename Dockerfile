# Dockerfile
# Stage 1: build environment
FROM python:3.11-slim AS builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt
RUN pip install --no-cache-dir fastapi uvicorn


# Copy app and model
COPY app ./app
COPY model ./model

# Stage 2: final image
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Copy app and model
COPY app ./app
COPY model ./model

# Use non-root user
RUN useradd -m appuser
USER appuser

# Expose port and run API
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
