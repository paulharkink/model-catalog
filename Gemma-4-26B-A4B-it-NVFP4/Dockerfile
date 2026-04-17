FROM vllm/vllm-openai:v0.19.0

RUN pip install --no-cache-dir "transformers==5.5.4"
COPY ./patches/gemma4_patched.py /usr/local/lib/python3.12/dist-packages/vllm/model_executor/models/gemma4.py

ENV VLLM_NVFP4_GEMM_BACKEND=marlin
ENV HF_HOME=/models
ENV HF_HUB_CACHE=/models

ENTRYPOINT ["vllm", "serve"]
CMD ["bg-digitalservices/Gemma-4-26B-A4B-it-NVFP4", "--quantization", "modelopt", "--moe-backend", "marlin", "--trust-remote-code", "--enable-auto-tool-choice", "--tool-call-parser", "gemma4", "--host", "0.0.0.0", "--port", "8000"]
