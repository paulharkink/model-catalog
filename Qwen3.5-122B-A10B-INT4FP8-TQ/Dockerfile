ARG BASE_IMAGE=docker.internal.phis.nl/vllm-eugr:v0.20.1
FROM ${BASE_IMAGE}

ARG ALBOND_COMMIT=42699e6a4bffecbf43ee3f26436c067eceb2a4aa
ARG ALBOND_RAW=https://raw.githubusercontent.com/albond/DGX_Spark_Qwen3.5-122B-A10B-AR-INT4/${ALBOND_COMMIT}

RUN mkdir -p /opt/patches/tq_src/ops /opt/patches/tq_src/backends \
 && curl -fsSL ${ALBOND_RAW}/patches/01-hybrid-int4-fp8/inc.py \
      -o /usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/quantization/inc.py \
 && curl -fsSL ${ALBOND_RAW}/patches/03-int8-lm-head/patch_int8_lmhead.py \
      -o /opt/patches/patch_int8_lmhead.py \
 && python3 /opt/patches/patch_int8_lmhead.py \
 && grep -q DGX_SPARK_INT8_LMHEAD_V2 \
      /usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/logits_processor.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/patch_turboquant_v2.py \
      -o /opt/patches/patch_turboquant.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/turboquant_kv_cache.py \
      -o /opt/patches/tq_src/ops/turboquant_kv_cache.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/turboquant_metadata.py \
      -o /opt/patches/tq_src/ops/turboquant_metadata.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/triton_turboquant_decode.py \
      -o /opt/patches/tq_src/ops/triton_turboquant_decode.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/triton_turboquant_kv_update.py \
      -o /opt/patches/tq_src/ops/triton_turboquant_kv_update.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/selector.py \
      -o /opt/patches/tq_src/selector.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/triton_attn.py \
      -o /opt/patches/tq_src/backends/triton_attn.py \
 && curl -fsSL ${ALBOND_RAW}/patches/04-turboquant/kv_cache_interface.py \
      -o /opt/patches/tq_src/kv_cache_interface.py \
 && python3 /opt/patches/patch_turboquant.py

ENV HF_HOME=/models
ENV HF_HUB_CACHE=/models

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
