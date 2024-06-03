import torch
from torch.utils.data import DataLoader, Dataset


# Define a custom Dataset
class AccDataset(Dataset):
    def __init__(self, features, labels):
        self.features = torch.tensor(features, dtype=torch.float32)  # Convert features to PyTorch tensors

    def __len__(self):
        return len(self.features)

    def __getitem__(self, idx):
        return self.features[idx], self.labels[idx]


def prepare_data_loaders(train_features, train_labels, test_features, test_labels, batch_size=10):
    train_dataset = AccDataset(train_features, train_labels)
    test_dataset = AccDataset(test_features, test_labels)

    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    test_loader = DataLoader(test_dataset, batch_size=batch_size, shuffle=False)

    return train_loader, test_loader
