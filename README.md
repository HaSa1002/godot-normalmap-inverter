# Godot Normalmap inversion tool
More often than not, normalmaps tend to come in DirectX format when using sources like [AmbientCG](https://ambientcg.com). However Godot expects normalmaps to be in OpenGL format. The difference between them is the green color channel. All this tool does, is to invert it.

You can either use the tool via **Project**->**Tools** or use a shortcut:

`Ctrl+T`,`Ctrl+N` if you wish to get a copy of the texture or

`Ctrl+T`,`Ctrl+I` if you wish to replace the texture.

The file selected in the file system dock is read.