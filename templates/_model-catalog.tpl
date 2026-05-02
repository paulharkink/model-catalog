{{/*
Dispatcher: routes to per-model podTemplateSpec by slug.
Slug is the entry name with "-local" suffix removed.
Usage: {{ include "model-catalog.podTemplateSpec" (dict "slug" $slug) }}
*/}}
{{- define "model-catalog.podTemplateSpec" -}}
{{- $slug := .slug -}}
{{- if eq $slug "qwen36-27b-nvfp4" }}{{ include "model-catalog.qwen36-27b-nvfp4.podTemplateSpec" . }}
{{- else if eq $slug "qwen36-35b-a3b-nvfp4" }}{{ include "model-catalog.qwen36-35b-a3b-nvfp4.podTemplateSpec" . }}
{{- else if eq $slug "gemma4-26b-a4b-nvfp4" }}{{ include "model-catalog.gemma4-26b-a4b-nvfp4.podTemplateSpec" . }}
{{- else if eq $slug "qwen25-32b-gguf-q4km-turboquant" }}{{ include "model-catalog.qwen25-32b-gguf-q4km-turboquant.podTemplateSpec" . }}
{{- else if eq $slug "llamacpp-turboquant" }}{{ include "model-catalog.llamacpp-turboquant.podTemplateSpec" . }}
{{- else if eq $slug "qwen35-122b-int4fp8" }}{{ include "model-catalog.qwen35-122b-int4fp8.podTemplateSpec" . }}
{{- else if eq $slug "qwen35-122b-int4fp8-tq" }}{{ include "model-catalog.qwen35-122b-int4fp8-tq.podTemplateSpec" . }}
{{- else }}{{ fail (printf "model-catalog: unknown slug %q" $slug) }}
{{- end -}}
{{- end -}}

{{- define "model-catalog.qwen36-27b-nvfp4.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/vllm-qwen36-27b-nvfp4:0.19.1
    ports:
      - name: http
        containerPort: 8000
    volumeMounts:
      - name: models
        mountPath: /models
    env:
      - name: HF_HOME
        value: /models
      - name: HF_HUB_CACHE
        value: /models
{{- end -}}

{{- define "model-catalog.qwen36-35b-a3b-nvfp4.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/vllm-qwen36-35b-a3b-nvfp4:0.19.1
    ports:
      - name: http
        containerPort: 8000
    volumeMounts:
      - name: models
        mountPath: /models
    env:
      - name: HF_HOME
        value: /models
      - name: HF_HUB_CACHE
        value: /models
{{- end -}}

{{- define "model-catalog.gemma4-26b-a4b-nvfp4.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/gemma4-26b-a4b-nvfp4-vllm:0.19.0
    ports:
      - name: http
        containerPort: 8000
    volumeMounts:
      - name: models
        mountPath: /models
    env:
      - name: HF_HOME
        value: /models
      - name: HF_HUB_CACHE
        value: /models
      - name: VLLM_NVFP4_GEMM_BACKEND
        value: marlin
{{- end -}}

{{- define "model-catalog.qwen25-32b-gguf-q4km-turboquant.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/qwen25-32b-gguf-q4km-tq:cuda-12.8.1
    ports:
      - name: http
        containerPort: 8080
    volumeMounts:
      - name: models
        mountPath: /models
{{- end -}}

{{- define "model-catalog.llamacpp-turboquant.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/qwen25-32b-gguf-q4km-tq:cuda-12.8.1
    ports:
      - name: http
        containerPort: 8080
    volumeMounts:
      - name: models
        mountPath: /models
{{- end -}}

{{- define "model-catalog.qwen35-122b-int4fp8.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/vllm-qwen35-122b-a10b-int4fp8:0.19.0
    args:
      - serve
      - /models/qwen35-122b-hybrid-int4fp8
      - --served-model-name
      - qwen35-122b-int4fp8
      - --max-model-len
      - "262144"
      - --gpu-memory-utilization
      - "0.90"
      - --reasoning-parser
      - qwen3
      - --attention-backend
      - FLASHINFER
      - --speculative-config
      - '{"method":"mtp","num_speculative_tokens":2}'
      - --language-model-only
      - --host
      - 0.0.0.0
      - --port
      - "8000"
    ports:
      - name: http
        containerPort: 8000
    volumeMounts:
      - name: models
        mountPath: /models
    env:
      - name: HF_HOME
        value: /models
      - name: HF_HUB_CACHE
        value: /models
{{- end -}}

{{- define "model-catalog.qwen35-122b-int4fp8-tq.podTemplateSpec" -}}
containers:
  - name: vllm
    image: docker.internal.phis.nl/vllm-qwen35-122b-a10b-int4fp8-tq:0.19.0
    args:
      - serve
      - /models/qwen35-122b-hybrid-int4fp8
      - --served-model-name
      - qwen35-122b-int4fp8-tq
      - --max-model-len
      - "262144"
      - --gpu-memory-utilization
      - "0.90"
      - --reasoning-parser
      - qwen3
      - --attention-backend
      - FLASHINFER
      - --kv-cache-dtype
      - turboquant35
      - --enable-turboquant
      - --turboquant-metadata-path
      - /models/qwen35-122b-hybrid-int4fp8/turboquant_kv.json
      - --speculative-config
      - '{"method":"mtp","num_speculative_tokens":2}'
      - --language-model-only
      - --host
      - 0.0.0.0
      - --port
      - "8000"
    ports:
      - name: http
        containerPort: 8000
    volumeMounts:
      - name: models
        mountPath: /models
    env:
      - name: HF_HOME
        value: /models
      - name: HF_HUB_CACHE
        value: /models
{{- end -}}
