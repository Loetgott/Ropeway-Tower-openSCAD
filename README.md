# 🚠 Ropeway Tower OpenSCAD (3S Seilbahn Stütze)

A fully parametric OpenSCAD project for generating a model ropeway tower (specifically designed for 3S aerial tramways).

This project allows you to customize and generate 3D printable STL files of a ropeway tower for your model ropeway setups.

[![Instagram](https://img.shields.io/badge/Instagram-seilbahn__modellbau-E4405F?style=flat&logo=instagram&logoColor=white)](https://www.instagram.com/seilbahn_modellbau/)

## ✨ Features

- **Fully Parametric:** Adjust the tower's height, number of floors, angles, and rod diameters to fit your specific needs.
- **Customizable Details:** Toggle the rendering of structural rods and construction helpers.
- **3D Printing Ready:** Easily export the generated models as STL files for your 3D printer. (A pre-rendered `stütze.stl` is included in the repository).
- **JSON Parameter Support:** Comes with a preset `stütze.json` file for easy parameter management in the OpenSCAD Customizer.

## 🛠️ Requirements

- [OpenSCAD](https://openscad.org/downloads.html) (Version 2021.01 or newer recommended)

## 🚀 Usage

1. Clone or download this repository.
2. Open the `stütze.scad` file in OpenSCAD.
3. Use the **Customizer** panel in OpenSCAD (if hidden, enable it via *Window -> Customizer*) to load the `stütze.json` preset or modify the parameters manually.
4. Adjust the parameters to your liking (see the Parameters section below).
5. Press `F5` to preview your changes.
6. Press `F6` to render the final geometry.
7. Click on *File -> Export -> Export as STL* to save your model for 3D printing.

## ⚙️ Parameters

You can adjust these variables directly in the OpenSCAD customizer or at the top of the `stütze.scad` file:

| Parameter | Description | Default Preset |
| :--- | :--- | :--- |
| `height` | The total height of the tower structure. | `600` |
| `angle` | The main inclination angle of the tower framework. | `15` |
| `angle_on_top` | The angle of the top saddle structure. | `51` |
| `floor_count` | Number of intermediate floors/cross-sections. | `3` |
| `big_rod_diameter` | Diameter of the primary vertical and horizontal structural rods. | `5` |
| `small_rod_diameter` | Diameter of the secondary diagonal supporting rods. | `3` |
| `draw_rods` | Toggle to render the threaded rods (`true`/`false`). | `true` |
| `draw_construction_helpers`| Toggle to show construction vectors and points (useful for debugging). | `false` |

## 📸 Media / More Info

For more pictures, videos, and updates about model ropeway projects, check out the Instagram page:

👉 **[@seilbahn_modellbau](https://www.instagram.com/seilbahn_modellbau/)**

## 📝 License

Feel free to modify, print, and share your creations for your model ropeways!
