import torch
import torch.nn as nn
from torchviz import make_dot


class IMOTION_CNN(nn.Module):
    def __init__(self, in_feature=600, in_channel=1, out_feature=8, pool_window_size=4, pool_stride_size=2,
                 pool_padding=1, conv_filter_list=[32, 64, 64, 64, 64, 64], conv_kernel_list=[15, 10, 10, 5, 5, 5],
                 conv_stride=1, full_connection_size=200):
        super(IMOTION_CNN, self).__init__()
        self.pool = nn.MaxPool1d(kernel_size=pool_window_size, stride=pool_stride_size, padding=pool_padding)
        assert len(conv_filter_list) == len(conv_kernel_list)
        self.conv_layers = nn.ModuleList([
            nn.Conv1d(in_channels=in_channel if i == 0 else conv_filter_list[i - 1],
                      out_channels=conv_filter_list[i],
                      kernel_size=conv_kernel_list[i], stride=conv_stride,
                      padding=self.calculate_padding(conv_kernel_list[i]))
            for i in range(len(conv_filter_list))
        ])
        self.final_matrix_size = conv_filter_list[-1] * (in_feature // (2 ** (len(conv_filter_list))))
        self.fc1 = nn.Linear(self.final_matrix_size, full_connection_size)
        self.fc2 = nn.Linear(full_connection_size, out_feature)

    def calculate_padding(self, kernel_size):
        return (kernel_size - 1) // 2

    def forward(self, x):
        print(self.final_matrix_size / con_filter_list[-1])
        for conv in self.conv_layers:
            x = self.pool(torch.relu(conv(x)))
        x = x.view(x.shape[0], -1)  # Flattening the tensor
        x = torch.relu(self.fc1(x))
        x = self.fc2(x)
        return x


# Initialize the model
model = IMOTION_CNN()

# Create a dummy input tensor
x = torch.randn(1, 1, 600)  # Batch size of 1, 1 input channel, 600 features

# Perform a forward pass to get the output
y = model(x)

# Visualize the model
make_dot(y, params=dict(list(model.named_parameters()))).render("imotion_cnn", format="png")
