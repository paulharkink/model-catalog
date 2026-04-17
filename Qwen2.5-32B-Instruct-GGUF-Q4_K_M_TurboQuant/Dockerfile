FROM docker.internal.phis.nl/llama.cpp_turboquant:cuda-12.8.1

ENV LLAMA_CACHE=/models

ENTRYPOINT ["/app/llama-server"]
CMD ["-hf", "bartowski/Qwen2.5-32B-Instruct-GGUF:Q4_K_M", "-c", "200000", "--cache-type-k", "q8_0", "--cache-type-v", "tbq3", "-ngl", "999", "--host", "0.0.0.0", "--port", "8080"]
