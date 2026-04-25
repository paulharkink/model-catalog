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
    image: docker.internal.phis.nl/qwen3_6_27b_nvfp4_vllm:0.19.1
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
    image: docker.internal.phis.nl/qwen3_6_35b_a3b_nvfp4_vllm:0.19.1
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
    image: docker.internal.phis.nl/gemma4_26b_a4b_nvfp4_vllm:0.19.0
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
    image: docker.internal.phis.nl/qwen2_5_32b_q4km_tq_llamacpp:cuda-12.8.1
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
    image: docker.internal.phis.nl/qwen2_5_32b_q4km_tq_llamacpp:cuda-12.8.1
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
    image: docker.internal.phis.nl/qwen3_5_122b_a10b_int4fp8_vllm:0.19.0
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
    image: docker.internal.phis.nl/qwen3_5_122b_a10b_int4fp8_tq_vllm:0.19.0
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
