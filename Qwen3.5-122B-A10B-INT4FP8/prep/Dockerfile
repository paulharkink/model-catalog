FROM python:3.12-slim

ARG ALBOND_COMMIT=42699e6a4bffecbf43ee3f26436c067eceb2a4aa
ARG ALBOND_RAW=https://raw.githubusercontent.com/albond/DGX_Spark_Qwen3.5-122B-A10B-AR-INT4/${ALBOND_COMMIT}

RUN pip install --no-cache-dir huggingface_hub safetensors numpy torch \
      --index-url https://download.pytorch.org/whl/cpu \
 && mkdir -p /opt/prep \
 && curl -fsSL ${ALBOND_RAW}/patches/01-hybrid-int4-fp8/build-hybrid-checkpoint.py \
      -o /opt/prep/build-hybrid-checkpoint.py \
 && curl -fsSL ${ALBOND_RAW}/patches/02-mtp-speculative/add-mtp-weights.py \
      -o /opt/prep/add-mtp-weights.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/generate_tq_metadata.py \
      -o /opt/prep/generate_tq_metadata.py

COPY entrypoint.sh /opt/prep/entrypoint.sh
RUN chmod +x /opt/prep/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/opt/prep/entrypoint.sh"]
