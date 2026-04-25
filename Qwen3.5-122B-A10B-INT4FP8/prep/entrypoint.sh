#!/bin/sh
set -e

MODEL_DIR="/models/qwen35-122b-hybrid-int4fp8"
SENTINEL="${MODEL_DIR}/model-00014-of-00014.safetensors"
TQ_SENTINEL="${MODEL_DIR}/turboquant_kv.json"

if [ -f "$SENTINEL" ]; then
  echo "Model already prepared at ${MODEL_DIR}, skipping weight merge."
else
  echo "Downloading Intel/Qwen3.5-122B-A10B-int4-AutoRound..."
  python3 -c "from huggingface_hub import snapshot_download; snapshot_download('Intel/Qwen3.5-122B-A10B-int4-AutoRound')"
  INTEL_DIR=$(python3 -c "from huggingface_hub import snapshot_download; print(snapshot_download('Intel/Qwen3.5-122B-A10B-int4-AutoRound', local_files_only=True))")

  echo "Building hybrid INT4+FP8 checkpoint..."
  python3 /opt/prep/build-hybrid-checkpoint.py \
    --gptq-dir "${INTEL_DIR}" \
    --fp8-repo Qwen/Qwen3.5-122B-A10B-FP8 \
    --output "${MODEL_DIR}"

  echo "Adding MTP weights..."
  python3 /opt/prep/add-mtp-weights.py \
    --source "${INTEL_DIR}" \
    --target "${MODEL_DIR}"

  echo "Model weight preparation complete."
fi

if [ -f "$TQ_SENTINEL" ]; then
  echo "TurboQuant metadata already present, skipping."
else
  echo "Generating TurboQuant KV cache metadata..."
  python3 /opt/prep/generate_tq_metadata.py \
    --model-dir "${MODEL_DIR}" \
    --output "${TQ_SENTINEL}"
  echo "TurboQuant metadata generation complete."
fi
