# Waterfall shader (Godot 4)

Spatial shader for flowing, transparent water. This repo is a small sample scene; the shader itself can be applied to any mesh.

Requires **Godot 4.7**. Open the project and run `Scene_Waterfall.tscn` (F5).

## Using the shader in your project

Copy these files into your project:

- `waterfall.gdshader`
- `waterfall_tex.png` (flow / alpha)
- `Water_N_A2.png` (normal map)

Then:

1. Select a `MeshInstance3D` (or any node with a mesh).
2. In the Inspector, create a **ShaderMaterial** (Surface Material Override, or the mesh’s material slot).
3. Assign `waterfall.gdshader` as the shader.
4. Fill the uniforms:

| Uniform | What to assign |
| --- | --- |
| `water_tex` | `waterfall_tex.png` (or any flow texture with alpha) |
| `normal_tex` | `Water_N_A2.png` (import as a normal map) |
| `noise_tex` | A `NoiseTexture2D` with a `FastNoiseLite` resource, **Seamless** enabled |

5. Tune colors and motion (`light_color`, `dark_color`, `speed`, `displ_amount`, `strength`, `frequency`, `time_factor`).

You can duplicate `Waterfall.tres` instead of building the material from scratch.

### Mesh requirements

- The mesh needs **UVs**. Flow is driven by scrolling `UV.y`, so unwrap so **V points along the flow**.
- Vertex waves displace along **local Y** and sample `VERTEX.yz`. That matches a vertical waterfall. For a horizontal surface, change the vertex function to sample `VERTEX.xz` (still displace `VERTEX.y`).
- Waves need **subdivision**. A two-triangle plane will not deform.

### Parameters

- **speed** — scroll rate of UVs, normals, and noise.
- **displ_amount** — how much `water_tex` warps the noise lookup.
- **strength / frequency / time_factor** — amplitude, spatial frequency, and speed of the vertex waves (X and Y components).
- **light_color / dark_color** — mixed by quantized noise; alpha on `water_tex` controls transparency.

The shader uses alpha blending and `cull_disabled`. Transparent sorting with other alpha meshes can be wrong; raise `render_priority` on the material if needed.

The mist in the sample is a separate `GPUParticles3D` node. It is not part of the shader.
