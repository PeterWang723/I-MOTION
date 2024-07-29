import torch
import coremltools as ct

model = torch.jit.load("mode_prediction.pt", map_location="cpu")
model.eval()
dummy_input = torch.rand(1, 600)

mlmodel = ct.converters.convert(
    model,
    inputs=[ct.TensorType(shape=dummy_input.shape)]
)

mlmodel.save("model.mlpackage")