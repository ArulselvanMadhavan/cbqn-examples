⟨⟨red, green, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"
rec←20
spacing ← 70
ctrlPtX ← 100
ctrlPtY ← 100
dims ← 7‿7
nd ← ≠dims
dims_xy ← dims ∾ 2
grid←spacing + (rec+spacing)×>⥊↕dims
r.window.SetSize 0.5

AddCtrlPts ←{dim_id𝕊[x1‿y1⋄x2‿y2]:
  ctrlOffsets ← [[(5÷ctrlPtX)‿0, (¯1×ctrlPtX)‿0], [(0‿(5 ÷ ctrlPtY)), (0‿(¯1×ctrlPtY))]]
  ctrlOffset ← dim_id⊏ctrlOffsets
  plus ← 0⊏ctrlOffset
  sub ← 1⊏ctrlOffset
  res ← (∾⟜((+⟜plus)≍(sub⊸+)))˘ 𝕩
  # Convert mxnxk - (mxn)xk and then convert rank 2 array to list of lists
  <⥊∘(⋈⎉(¯1))∘∾⋈⎉¯1 res
}

DrawBezier ← {r‿g‿b‿a𝕊pts:
    args ← pts∾4∾2.0⋈𝕨
    raylib.DrawSplineBezierCubic args
}⎉1‿2

GenOff ← {𝕊𝕩:
      midtp ← 𝕩
      lastDim ← 1↓↕(¯2⊸⊑≢) midtp
      rotations ← {(𝕩⊸⌽)⎉2 midtp}¨ lastDim
      {midtp ≍⎉1 𝕩}¨ rotations
  }

PerFrame ← {𝕤
    pos ← r.mouse.GetPos@
    ellipseGrid ← {≍⟜(+⟜rec)}˘ grid
    {white r.draw.EllipseOutline 𝕩}˘ ellipseGrid
    midpts ← ÷⟜2∘+˝⎉2 ellipseGrid
    midpts_xy ← dims_xy ⥊ midpts
    axisRots ← ((↕≠dims)⊸(⌽˜))¨ ↕≠dims
    offsets ← (GenOff∘(midptsxy⊸(⍉˜)))¨ axisRots
    # offsets - dims x rots_per_dim x dim_1 x dim_n x 2
    flags ← (⌽∘↕nd) {(𝕨⊸⊑∘<˝⎉2)¨𝕩}¨ offsets
    # flags - dims x rots_per_dim x dim_1 x dim_2
    curves ← flags (/˘)¨¨ offsets
    curvePts ← (↕nd) {𝕨⊸AddCtrlPts˘˘¨ 𝕩}¨ curves
    {red DrawBezier 𝕩}˘˘¨¨ curvePts
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "HyperX"
