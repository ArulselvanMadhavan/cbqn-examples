⟨⟨red, white, black⟩⇐color⟩←r←•Import "../rayed-bqn/rayed.bqn"
rec←12 ⋄ cir←400
spacing ← 5
distanceFromMiddle ← 170
outerRecs ← distanceFromMiddle×¯1+2×>⥊↕2‿2
ex←(rec+spacing)×>⥊↕9‿9
r.window.SetSize 0.5
PerFrame ← {𝕤
  pos ← r.mouse.GetPos@
#red     r.draw.Ellipse   cir⊸+⊸≍  pos-cir÷2
#{white   r.draw.Rectangle rec⊸+⊸≍𝕩+pos-rec÷2}˘outerRecs
  {white r.draw.Rectangle ≍⟜(+⟜rec)}˘ ex
}r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "HyperX"
