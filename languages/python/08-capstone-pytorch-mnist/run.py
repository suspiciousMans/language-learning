#!/usr/bin/env python3
"""Capstone: MNIST digit classification with PyTorch.

Fill in the TODO sections to build a complete training and evaluation pipeline.

Requirements (install yourself):
    pip install torch torchvision

Run:
    python3 run.py

Expected output:
    - Training loss per epoch
    - Final test accuracy (target: >= 90%)
    - A saved model file: mnist_model.pt
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

# =============================================================================
# TODO: Define your model in model.py and import it, or define it here.
# =============================================================================

# Example MLP (replace or extend with your own architecture):
class MNISTMLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.flatten = nn.Flatten()
        self.network = nn.Sequential(
            nn.Linear(28 * 28, 256),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(128, 10),
        )

    def forward(self, x):
        x = self.flatten(x)
        return self.network(x)


# =============================================================================
# TODO: Data loading
# =============================================================================

def load_data(batch_size: int = 64):
    """Download MNIST and return train and test DataLoaders.

    Normalize with mean=0.1307, std=0.3081 (standard MNIST normalization).
    """
    # TODO: define train and test transforms
    # TODO: download MNIST train and test datasets
    # TODO: create DataLoaders
    # TODO: return train_loader, test_loader
    raise NotImplementedError("Fill in load_data()")


# =============================================================================
# TODO: Training loop
# =============================================================================

def train(model, train_loader, optimizer, criterion, epoch, device):
    """Train for one epoch and print average loss."""
    # TODO: set model.train()
    # TODO: loop over batches
    # TODO: forward pass, compute loss, backward pass, optimizer step
    # TODO: accumulate and print average loss for the epoch
    raise NotImplementedError("Fill in train()")


# =============================================================================
# TODO: Evaluation
# =============================================================================

def evaluate(model, test_loader, device):
    """Evaluate the model on the test set and return accuracy."""
    # TODO: set model.eval()
    # TODO: loop over test batches with torch.no_grad()
    # TODO: compute correct predictions and total
    # TODO: return accuracy as a float (e.g., 0.94 for 94%)
    raise NotImplementedError("Fill in evaluate()")


# =============================================================================
# Main
# =============================================================================

def main():
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")

    # TODO: choose batch size, learning rate, number of epochs
    batch_size = 64
    learning_rate = 0.001
    epochs = 5

    # TODO: instantiate model, move to device
    model = MNISTMLP().to(device)

    # TODO: define loss function and optimizer
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    # TODO: load data
    train_loader, test_loader = load_data(batch_size)

    # TODO: training loop
    for epoch in range(1, epochs + 1):
        train(model, train_loader, optimizer, criterion, epoch, device)
        acc = evaluate(model, test_loader, device)
        print(f"Epoch {epoch}: test accuracy = {acc:.4f}")

    # TODO: save the model
    torch.save(model.state_dict(), "mnist_model.pt")
    print("Model saved to mnist_model.pt")

    # TODO: load the saved model and run a quick sanity check
    # (optional but recommended)
    model.load_state_dict(torch.load("mnist_model.pt", map_location=device))
    model.eval()
    sample = torch.randn(1, 1, 28, 28).to(device)
    with torch.no_grad():
        output = model(sample)
    print(f"Sanity check: model output shape = {output.shape}")


if __name__ == "__main__":
    main()
