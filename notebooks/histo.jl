### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ ff8b5178-f5da-11ea-0e48-aba5734be720
using Compose, Colors

# ╔═╡ 8f9cdc8a-f5fd-11ea-3559-97459fdd0302
using Plots

# ╔═╡ 5fa416a6-f6c5-11ea-0583-b14f00a7a500
using Javis, Luxor

# ╔═╡ c5862850-f7d9-11ea-0d2d-f7bd005f8563
using PlutoUI

# ╔═╡ 073bc512-f5db-11ea-0a86-f37569af49e0
set_default_graphic_size(10cm, 10cm)

# ╔═╡ ccfaf582-f5db-11ea-3ba0-db6ce278fc7c
xs = collect(range(0, stop=2π, length=60))

# ╔═╡ d04a0f9a-f5db-11ea-26c4-9ba19e283814
point_array = [[(x,0.0), (x,y)] for (x,y) in zip(LinRange(0,1,60), sin.(xs) .|> abs)]

# ╔═╡ d36d47d4-f5db-11ea-153e-9530ab2ad556
img = compose(context(),
    (context(), rectangle(), fill("white"), fillopacity(0.3)),
    (context(0.0, 0.0, 1.0, 1.0),
        line(point_array), stroke([LCHuvA(70.,50., 360*θ/2π, 0.4) for θ in xs]), linewidth(1mm))
)

# ╔═╡ dad13f04-f5fd-11ea-292a-73b8eb2954fd
ts = 1:0.02:10

# ╔═╡ 827021ac-f5fd-11ea-1c70-01ef31693bfb
vf6(ω, t) = 0.5 + 4*√2/π^2*sum(n->(n%8<4 ? 1 : -1)*sin(n*ω*t)/n^2, 1:2:11)

# ╔═╡ e9e93580-f5fd-11ea-18af-5f59b391393e
plot(ts, vf6.(1.0, ts))

# ╔═╡ 53a51f06-f6c5-11ea-2f16-a7836fc21499
myvideo = Video(500, 500)

# ╔═╡ 2e81e086-f7d9-11ea-0d0f-6db203e33031
function ground(args...) 
    background("white") # canvas background
    sethue("black") # pen color
end

# ╔═╡ 3c8bbb64-f7d9-11ea-3d61-b11baee66b61
function object(p=O, color="black")
    sethue(color)
    Luxor.circle(p, 25, :fill)
    return p
end

# ╔═╡ 5e783014-f6c5-11ea-0d98-53cd4223f1c8
md"""$(LocalResource(javis(
    myvideo,  
    [
        BackgroundAction(1:70, ground),
        Action(1:70,:red_ball, (args...)->object(Point(100,0), "red"), Javis.Rotation(0.0, 2π)),
    ],
    pathname="rotation.gif"
)))"""

# ╔═╡ Cell order:
# ╠═ff8b5178-f5da-11ea-0e48-aba5734be720
# ╠═073bc512-f5db-11ea-0a86-f37569af49e0
# ╠═ccfaf582-f5db-11ea-3ba0-db6ce278fc7c
# ╠═d04a0f9a-f5db-11ea-26c4-9ba19e283814
# ╠═d36d47d4-f5db-11ea-153e-9530ab2ad556
# ╠═8f9cdc8a-f5fd-11ea-3559-97459fdd0302
# ╠═dad13f04-f5fd-11ea-292a-73b8eb2954fd
# ╠═827021ac-f5fd-11ea-1c70-01ef31693bfb
# ╠═e9e93580-f5fd-11ea-18af-5f59b391393e
# ╠═5fa416a6-f6c5-11ea-0583-b14f00a7a500
# ╠═53a51f06-f6c5-11ea-2f16-a7836fc21499
# ╠═2e81e086-f7d9-11ea-0d0f-6db203e33031
# ╠═3c8bbb64-f7d9-11ea-3d61-b11baee66b61
# ╠═c5862850-f7d9-11ea-0d2d-f7bd005f8563
# ╟─5e783014-f6c5-11ea-0d98-53cd4223f1c8
