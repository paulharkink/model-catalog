FROM docker.internal.phis.nl/vllm-qwen35-base-tq:0.19.0

ENTRYPOINT ["vllm"]
CMD ["serve", "/models/qwen35-122b-hybrid-int4fp8", \
     "--served-model-name", "qwen35-122b-int4fp8-tq", \
     "--max-model-len", "262144", \
     "--gpu-memory-utilization", "0.90", \
     "--reasoning-parser", "qwen3", \
     "--attention-backend", "FLASHINFER", \
     "--kv-cache-dtype", "turboquant35", \
     "--enable-turboquant", \
     "--turboquant-metadata-path", "/models/qwen35-122b-hybrid-int4fp8/turboquant_kv.json", \
     "--speculative-config", "{\"method\":\"mtp\",\"num_speculative_tokens\":2}", \
     "--language-model-only", \
     "--host", "0.0.0.0", \
     "--port", "8000"]
