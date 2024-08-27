import torch
import coremltools as ct

# Load your PyTorch model
model = torch.jit.load("mode_prediction.pt", map_location="cpu")
model.eval()

# Define a dummy input with the same shape as your model expects
dummy_input = torch.rand(1, 1, 600)

# Convert the PyTorch model to Core ML
coreml_model = ct.convert(
    model,
    inputs=[ct.TensorType(shape=dummy_input.shape)]
)

# Save the Core ML model as a .mlpackage
coreml_model.save("mode_prediction.mlpackage")