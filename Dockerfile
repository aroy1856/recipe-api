FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install dependencies
COPY pyproject.toml uv.lock ./
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then \
      uv sync --frozen --no-install-project --group dev; \
    else \
      uv sync --frozen --no-install-project; \
    fi

# Copy application
COPY app/ app/ 
COPY entrypoint.sh entrypoint.sh

# Make entrypoint executable
RUN chmod +x entrypoint.sh

EXPOSE 8000

CMD ["/app/entrypoint.sh"]
