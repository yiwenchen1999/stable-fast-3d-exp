sudo apt-get update
sudo apt-get install -y python3.10-dev build-essential
python3.10 -m venv ~/venv/SF3D
source ~/venv/SF3D/bin/activate
pip install -r requirements.txt
# Run locally; never commit tokens. Option: export HF_TOKEN=... then use the CLI or Python hub.
huggingface-cli login