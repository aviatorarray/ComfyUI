# =============================================================================
# Custom ComfyUI Docker Image - Built Directly From Official Source Code
# Base: Official PyTorch 2.5.1 with CUDA 12.4 Runtime & cuDNN 9
# =============================================================================
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Install system dependencies (git for node updates, ffmpeg for media, libgl for image processing)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/ComfyUI

# Install dependencies from official requirements.txt
COPY requirements.txt /app/ComfyUI/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy source code into container image
COPY . /app/ComfyUI

EXPOSE 8188

ENTRYPOINT ["python", "main.py"]
CMD ["--listen", "0.0.0.0", "--port", "8188", "--enable-cors-header", "*"]
