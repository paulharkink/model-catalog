FROM docker.internal.phis.nl/vllm-eugr:v0.20.1

ENV HF_HOME=/models
ENV HF_HUB_CACHE=/models

ENTRYPOINT ["vllm", "serve"]
CMD ["RedHatAI/Qwen3.5-122B-A10B-NVFP4", \
     "--max-model-len", "262144", \
     "--max-num-batched-tokens", "2096", \
     "--reasoning-parser", "qwen3", \
     "--enable-auto-tool-choice", \
     "--tool-call-parser", "qwen3_coder", \
     "--language-model-only", \
     "--gpu-memory-utilization", "0.90", \
     "--dtype", "auto", \
     "--trust-remote-code", \
     "--host", "0.0.0.0", \
     "--port", "8000"]
