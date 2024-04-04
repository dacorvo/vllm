#!/bin/bash
model_id=${1:-meta-llama/Llama-2-7b-chat-hf}
port=${2:-8000}
cores=${3:-0-7}

export vLLM_MAX_LEN=4096
export vLLM_MODEL_ID=${model_id}
export vLLM_CONT_BATCH_SIZE=32 #continuous batching size for neuronx-tnx
export vLLM_TENSOR_PARALLEL_SIZE=8
export NEURON_RT_VISIBLE_CORES=${cores}
export MASTER_PORT=12355
export OMP_NUM_THREADS=32
numactl --cpunodebind=0 --membind=0 \
	python3 -m vllm.entrypoints.openai.api_server \
	    --model ${vLLM_MODEL_ID} \
	    --tensor-parallel-size ${vLLM_TENSOR_PARALLEL_SIZE} \
	    --max-num-seqs ${vLLM_CONT_BATCH_SIZE} \
	    --max-model-len ${vLLM_MAX_LEN} \
	    --block-size ${vLLM_MAX_LEN} \
	    --port ${port}
