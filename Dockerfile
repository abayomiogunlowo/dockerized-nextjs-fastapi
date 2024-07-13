# Use a base image with both Python and Node.js installed
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

# Set the working directory
WORKDIR /dockerized-nextjs-fastapi

# Copy FastAPI requirements and install them
COPY requirements.txt /dockerized-nextjs-fastapi/requirements.txt
RUN pip install --no-cache-dir -r /dockerized-nextjs-fastapi/requirements.txt

# Copy the FastAPI application code
COPY ./api /nextjs-fastapi/api

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Copy frontend package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the entire application code
COPY . /dockerized-nextjs-fastapi

# Build the Next.js application
RUN npm run build

# Expose necessary ports
EXPOSE 3000 8000

# Start both FastAPI and Next.js
CMD ["sh", "-c", "uvicorn api.index:app --host 0.0.0.0 --port 8000 & npm start"]
