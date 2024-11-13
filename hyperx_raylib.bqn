⟨⟨red, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"
rec←20
spacing ← 70
ctrlPtOffset ← 100
dims ← 9‿9
dims_xy ← dims ∾ 2
grid←spacing + (rec+spacing)×>⥊↕dims
r.window.SetSize 0.5

DrawBezier ← {r‿g‿b‿a𝕊[x1‿y1⋄x2‿y2]:
    ctrlPts ← (∾⟜((+⟜(5÷ctrlPtOffset)‿0)≍((¯1×ctrlPtOffset)‿0⊸+)))˘ 𝕩
    arg1 ← ⋈⥊<˘˘ctrlPts
    args ← arg1∾4∾2.0⋈𝕨
    raylib.DrawSplineBezierCubic args
}⎉1‿2

PerFrame ← {𝕤
    pos ← r.mouse.GetPos@
    ellipseGrid ← {≍⟜(+⟜rec)}˘ grid
    {white r.draw.EllipseOutline 𝕩}˘ ellipseGrid
    midpts ← ÷⟜2∘+˝⎉2 ellipseGrid
    midpts_xy ← dims_xy ⥊ midpts
    dim_idx ← 1
    neighbors ← 1⊸↓↕∘(dims⊸(⊑˜)) dim_idx
    offsets ← midptsxy⊸((⌽˜)˘)¨ neighbors
    offsetPairings ← midptsxy⊸(>∘⋈˘˘)¨ offsets
    # lineGrid ← midptsxy >∘⋈˘˘ oneoff
    # linesFlag ← midptsxy (¯1⊸⊑∘<)˘˘ oneoff
    # curvesFlag ← ¬linesFlag
    # curves ← curvesFlag /˘ lineGrid
    # lines ← linesFlag /˘ lineGrid
    curvesFlag ← midptsxy⊸((¯1⊸⊑∘<)˘˘)¨ offsets
    curves ← curvesFlag (/˘)¨ offsetPairings
    {red DrawBezier 𝕩}˘¨ curves
    # {red r.draw.Line 𝕩} lines
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "HyperX"
