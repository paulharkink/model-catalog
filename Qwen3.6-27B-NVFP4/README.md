# Qwen3.6-27B-NVFP4

This recipe is tuned for `sparky` as a max-context-first experiment.

## Why this variant

- Qwen's official `Qwen3.6-27B` supports up to `262144` tokens and recommends keeping at least `128K` context if memory is tight.
- The community NVFP4 derivative `sakamakismile/Qwen3.6-27B-NVFP4` reduces the published model size from `55.6 GB` to `19.7 GB` using `compressed-tensors`, which is a much better fit for preserving KV cache capacity on a single Blackwell system.
- NVIDIA documents DGX Spark as a `128 GB` unified-memory Grace Blackwell machine and explicitly warns that vLLM's default memory behavior can be too aggressive on unified-memory systems.

## Chosen serving profile

- model: `sakamakismile/Qwen3.6-27B-NVFP4`
- context: `262144`
- reasoning parser: `qwen3`
- tool parser: `qwen3_coder`
- mode: `--language-model-only`
- memory cap: `--gpu-memory-utilization 0.70`

## Why not higher precision first

The goal of this recipe is to preserve maximum context length rather than maximize numerical precision. If this profile still fails on `sparky`, the next knob should be another memory-saving step that keeps `262144` context, not a context reduction.

## PyTorch upgrade path

The baseline image installs `vllm==0.19.1+cu130`, which in turn pins:

- `torch==2.10.0`
- `torchvision==0.25.0`
- `torchaudio==2.10.0`

For GB10 / `sm_121`, that PyTorch build may be older than ideal even when the
CUDA runtime is correct. To test a newer PyTorch without changing the baseline
recipe, build with:

```bash
docker compose build --build-arg TORCH_CHANNEL=nightly
```

That keeps the same vLLM wheel but replaces only the PyTorch stack with the
latest arm64 CUDA 13 nightly wheels from `download.pytorch.org`.

## Current Blackwell notes

The current first-choice recipe now also includes:

- `transformers==5.5.4`
- `--max-num-batched-tokens 2096`

Those are based on the NVFP4 model card's tested software stack and the
upstream vLLM GDN/Blackwell workaround discussed in issue `#37714`.
