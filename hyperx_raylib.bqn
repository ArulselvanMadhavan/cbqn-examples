⟨⟨red, green, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"
rec←20
spacing ← 70
ctrlPtX ← 100
ctrlPtY ← 100
dims ← 3‿4
nd ← ≠dims
nsize ← ×´dims
mat ← nsize‿nsize
dims_xy ← dims ∾ 2
data ← (10⊸+)∘>∘(dims⊸⥊¨) ↕nsize
out_t ← +˝ data

axisRots ← ((↕≠dims)⊸(⌽˜))¨ ↕≠dims
revRots ← (((↕nd)⊸(⌽˜))∘(¯1⊸×))¨ ↕nd

grid←spacing + (rec+spacing)×>⥊↕dims
max_x‿max_y ← ⌈˝grid
min_x‿min_y ← ⌊˝grid
out_start ← (spacing + max_x)‿min_y
out_wid ← 3×rec
out_spacing ← (out_wid‿out_wid)
out_tl ← out_start⊸+˘out_wid×>⥊↕dims
out_lines ← (∾⟜out_spacing)˘ out_tl
out_br ← (out_wid⊸+)⎉¯1 out_tl
out_rect ← out_tl ≍˘ out_br
text_pos ← <∘(((÷⟜3)¨out_spacing)⊸+)∘⊏˘out_rect
out_txt ← text_pos ∾˘ (•Fmt¨ (⥊out_t))
r.window.SetSize 0.5

InitMat ← {1⌾(𝕩⊸⊑) 𝕨⥊0}

GenRot ← {𝕨𝕊𝕩:
    rots ← ¯1↓1+↕≠𝕩
    (𝕨⊸(⌽˜))˘ rots
}

# Generate step table
vars ← (dims⊸InitMat)¨ ↕dims
GenStageRots ← {(GenRot˜∘(𝕩⊸(⍉˜)))¨ axisRots}
# num_switches_m x stage_count_m x rots_per_stage_l x mat
rot_res ← >GenStageRots¨ ⥊vars
RevRot ← {(𝕨⊸⍉)˘ 𝕩}
hop_table ← {(revRots {𝕨 {RevRot}¨ 𝕩}˘ 𝕩)}˘ rot_res

Flip ← {
    HasFlag ← ((0⊸<)∘+´∘⥊)
    MaybeFlip ← HasFlag◶⟨⊢,¬⟩
    IsFlippable ← (0⊸<)∘(≠≢)
    Fn ← IsFlippable◶⟨⊢,MaybeFlip⟩
    Fn 𝕩
}

pkt_flags ← {(Flip⎉(𝕩))¨ vars}¨ (⌽↕nd)
dd ← >⋈⎉¯1 data
hop_reduce ← ⍉hop_table

HopRdc ← {𝕨𝕊hop_id:
    hop_d ← hop_id ⊏ hop_reduce
    pkt_d ← ⥊∘>(hop_id ⊏ pkt_flags)
    data ← >𝕨
    ldata ← (¯1⊸⊏)˘ 𝕨
    SwRdc ← {sw_id𝕊𝕩:
        sw_d ← (sw_id ⊏ ldata)
        pkt_f ← ⊑(sw_id ⊏ pkt_d)
        sw_f ← ⊑(sw_id ⊏ ⥊vars)
        StepRdc ← {
            pkt_f ← (sw_f ≡ pkt_f)⊑(pkt_f‿(pkt_f≠pkt_f))
            hop_d ← ⊑(⥊𝕩) / (<˘ ldata)
            pkt_d ← ×⟜hop_d¨ sw_f‿pkt_f
            +´ (⋈𝕨)∾pkt_d
        }
        outstep ← (<˘ sw_d) StepRdc` (⋈˘ 𝕩)
        ∾˘outstep
     }
     (↕(≢hop_d)) SwRdc˘ (>hop_d)
}

out_s ← (⋈ dd) HopRdc` (⋈˘ (↕(≠hop_reduce)))

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

DrawRectangleLines ← {r‿g‿b‿a𝕊x‿y‿wx‿wy:
   raylib.DrawRectangleLines⟨x, y, wx, wy, r‿g‿b‿a⟩
   #raylib.DrawRectangleLines 𝕨∾⟜<˜(⌈∾⊢-⊏∘𝕩)(+˝÷≠)𝕩
}⎉1‿2

GenOff ← {𝕊𝕩:
      midtp ← 𝕩
      lastDim ← 1↓↕(¯2⊸⊑≢) midtp
      rotations ← {(𝕩⊸⌽)⎉2 midtp}¨ lastDim
      {midtp ≍⎉1 𝕩}¨ rotations
  }

fontSize ← 20
PerFrame ← {𝕤
    pos ← r.mouse.GetPos@
    ellipseGrid ← {≍⟜(+⟜rec)}˘ grid
    {white r.draw.EllipseOutline 𝕩}˘ ellipseGrid
    #{white r.draw.Rectangle 𝕩}˘ out_rect
    font ← r.font.LoadRaylib@
    {white DrawRectangleLines 𝕩}˘ out_lines
    {white‿font‿fontSize r.draw.Text 𝕩}˘ out_txt
    midpts ← ÷⟜2∘+˝⎉2 ellipseGrid
    midpts_xy ← dims_xy ⥊ midpts
    offsets ← (GenOff∘(midptsxy⊸(⍉˜)))¨ axisRots
    flags ← (⌽∘↕nd) {(𝕨⊸⊑∘<˝⎉2)¨𝕩}¨ offsets
    curves ← flags (/˘)¨¨ offsets
    curvePts ← (↕nd) {𝕨⊸AddCtrlPts˘˘¨ 𝕩}¨ curves
    {red DrawBezier 𝕩}˘˘¨¨ curvePts
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "HyperX"
