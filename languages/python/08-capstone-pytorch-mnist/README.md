# 08 — Capstone: PyTorch MNIST

## Goals

Build a complete machine learning pipeline: load the MNIST dataset, define a neural network (CNN or MLP), train it, evaluate it, and save the trained model to disk.

## Concepts

- PyTorch tensors and autograd
- `torchvision.datasets.MNIST` and data transforms
- DataLoaders for batching
- Defining a neural network with `nn.Module`
- Training loops: forward pass, loss, backward pass, optimizer step
- Evaluation: accuracy, loss on a test set
- Model persistence: `torch.save` / `torch.load`
- Device selection (CPU vs. CUDA)

## Prerequisites

- All previous projects (00–07)
- PyTorch and torchvision installed by the learner:

```bash
pip install torch torchvision
```

> This capstone does not pin PyTorch in `requirements.txt` because installation is large and platform-specific. The learner installs it themselves.

## Acceptance Criteria

1. The script `run.py` runs end-to-end and produces a model file `mnist_model.pt` in the project folder.
2. The script prints training loss per epoch and final test accuracy.
3. The saved model can be loaded and run on a sample input.
4. The model achieves at least 90% test accuracy (reasonable for a simple CNN or MLP on MNIST).
5. The code is readable, commented, and structured into functions or classes (not one giant blob).

## Requirements

See `requirements.txt` for the pinned dependencies (torch, torchvision). The learner installs these.

## Files

- `run.py` — skeleton with `TODO` sections to fill in
- `requirements.txt` — torch and torchvision pins
- `model.py` — (optional) where the learner defines their network
- `README.md` — this file

## Skeleton: run.py

The `run.py` file contains a skeleton with `TODO` markers. Fill them in to build the pipeline.

## Running

```bash
pip install -r projects/08-capstone-pytorch-mnist/requirements.txt
python3 projects/08-capstone-pytorch-mnist/run.py
```

## Dataset

MNIST is downloaded automatically by torchvision the first time you run the script. It's about 10 MB.

## Hints

- Start with a simple MLP (2-3 fully-connected layers) to get the pipeline working, then upgrade to a CNN.
- Use `torch.nn.CrossEntropyLoss` for classification.
- Use `torch.optim.Adam` or `torch.optim.SGD`.
- Normalize images with mean=0.1307, std=0.3081 (standard MNIST normalization).
- Use `torch.no_grad()` during evaluation.
- Save with `torch.save(model.state_dict(), "mnist_model.pt")`.
