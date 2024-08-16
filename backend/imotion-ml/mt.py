import torch

model = torch.jit.load("mode_prediction.pt", map_location="cpu")
model.eval()
dummy_input = torch.rand(300, 1, 600)

output = model(dummy_input)

print(output)