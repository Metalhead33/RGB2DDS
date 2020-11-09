# rgb2dds

Generates a DDS image from a single-coloured RGB rectangle. Useful for creating decal textures for Crusader Kings 3.
Requires Inkscape first and foremost, and either [Nvidia Texture Tools](https://github.com/castano/nvidia-texture-tools) or [S2TC](https://github.com/divVerent/s2tc). Supported only on Linux

**Usage:**

    ./rgb2dds.sh NVENC|S2TC <r> <g> <b> <output.dds> <width> <height> <DXT1|DXT3|DXT5>
