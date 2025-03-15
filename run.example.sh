#!/bin/bash

# 数据集已下载到本地，避免外网再次访问
echo '0.0.0.0 huggingface.co' >> /etc/hosts

# 一定要设置此环境变量，要从当前目录找livebench包
export PYTHONPATH=$(cd $(dirname "$0");pwd)
cd $PYTHONPATH
. venv/bin/activate

export QIANFAN_API_DEBUG=true
export QIANFAN_API_TIMEOUT=240
export QIANFAN_API_KEY=sk-xxx
export QIANFAN_API_URL=http://47.108.78.149:8916/predict

python3 livebench/gen_api_answer.py --model qianfan-private --question-source huggingface --bench-name live_bench --parallel 2
python3 livebench/gen_ground_truth_judgment.py --model qianfan-private --question-source huggingface --bench-name live_bench --debug --parallel 4
python3 livebench/show_livebench_result.py --bench-name live_bench --model-list qianfan-private