import os
from pathlib import Path
from typing import Literal, Optional, List
import tyro
from torch.utils.data import DataLoader
from PIL import Image
import torch
from tqdm import tqdm

from vhap.data.image_folder_dataset import ImageFolderDataset

def robust_video_matting(image_dir: Path, N_warmup: Optional[int]=10):
    print(f'Running robust video matting on images in {image_dir}')
    model = torch.hub.load("PeterL1n/RobustVideoMatting", "resnet50").cuda()
    dataset = ImageFolderDataset(image_folder=image_dir)
    dataloader = DataLoader(dataset, batch_size=1, shuffle=False, num_workers=1)

    rec = [None] * 4
    downsample_ratio = 0.5
    for item in tqdm(dataloader):
        rgb = item['rgb']
        rgb = rgb.permute(0, 3, 1, 2).float().cuda() / 255
        with torch.no_grad():
            while N_warmup:
                fgr, pha, *rec = model(rgb, *rec, downsample_ratio)
                N_warmup -= 1
            fgr, pha, *rec = model(rgb, *rec, downsample_ratio)
        alpha = (pha[0, 0] * 255).cpu().numpy()
        alpha = Image.fromarray(alpha.astype('uint8'))
        alpha_path = item['image_path'][0].replace('images', 'alpha_maps')
        if not Path(alpha_path).parent.exists():
            Path(alpha_path).parent.mkdir(parents=True)
        alpha.save(alpha_path)


def main(
        image_dir: Path
    ):
    if not image_dir.exists():
        raise FileNotFoundError(f"Cannot find the image directory: {image_dir}")

    print(f'Processing image directory: {image_dir}')

    image_dir = Path(os.path.join(image_dir, 'images'))
    print(f'Image directory set to: {image_dir}')

    # Run the selected matting method
    robust_video_matting(image_dir)

if __name__ == '__main__':
    tyro.cli(main)
