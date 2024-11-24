⟨⟨red, green, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"
secs_per_step ← 3
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

grid ← ⌽⎉1 (spacing + (rec+spacing)×>⥊↕dims)
ellipseGrid ← {≍⟜(+⟜rec)}˘ grid
midpts ← (÷⟜2)+˝˘ellipseGrid
midpts_xy ← dims_xy ⥊ midpts

max_y‿max_x ← ⌈˝grid
min_y‿min_x ← ⌊˝grid
# display expected out
out_start ← (min_y)‿(max_x + (3 × spacing))
out_wid ← 3×rec
out_spacing ← (out_wid‿out_wid)
MkGridPts ← {(⌽⎉1) (𝕩⊸+˘out_wid×>⥊↕dims)}
out_tl ← MkGridPts out_start
MkGridLines ← (∾⟜out_spacing)˘
out_lines ← MkGridLines out_tl
out_br ← (out_wid⊸+)⎉¯1 out_tl
out_rect ← out_tl ≍˘ out_br
MkTextPos ← <∘(((÷⟜3)¨ out_spacing)⊸+)∘⊏˘
text_pos ← MkTextPos out_rect
FmtTxt ← {𝕨 ∾˘ (•Fmt¨ (⥊𝕩))}
out_txt ← text_pos FmtTxt out_t

out_max_y‿out_max_x ← ⌈˝out_br
aout_offset ← out_max_x‿0
aout_start ← out_start + aout_offset
aout_tl ← MkGridPts aout_start
aout_lines ← MkGridLines aout_tl
aout_rect ← ((⌽aout_offset)⊸+)˘˘ out_rect
atext_pos ← MkTextPos aout_rect

r.window.SetSize 0.25

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
hop_sw ← {{{((⊐⟜1)∘⥊)⎉2 𝕩}¨𝕩}˘ 𝕩}˘ hop_table
hop_comb ← ∾˘ hop_sw
conn_mat ← (nsize↑/⁼)˘ hop_comb
ut_mat ← <⌜˜↕nsize
link_mat ← ut_mat ∧ conn_mat
link_pts ← ≍⌜˜ <˘midpts
ulinks ← (⥊link_mat) / (⥊link_pts)
ctrlul ← ≍˘-40×((=˝)˘ (>ulinks))
ul_split ← ((↕nd)⊸⊔)˘ >ulinks
CtrlAdd ← {𝕩∾(𝕨+𝕩)}
sctrls ← ctrlul CtrlAdd˘ (0⊑˘ ul_split)
ectrls ← ctrlul (⌽CtrlAdd)˘ (1⊑˘ ul_split)
curves_join ← (sctrls ∾˘ ectrls)
curves ← (<(<˘))˘ curves_join

Flip ← {
    HasFlag ← ((0⊸<)∘+´∘⥊)
    MaybeFlip ← HasFlag◶⟨⊢,¬⟩
    IsFlippable ← (0⊸<)∘(≠≢)
    Fn ← IsFlippable◶⟨⊢,MaybeFlip⟩
    Fn 𝕩
}

hop_reduce ← ⍉hop_table
reduce_flags ← {(Flip⎉(𝕩))¨ vars}¨ (⌽↕nd)
rcomb ← hop_reduce {𝕨 {(⋈⟜𝕩)˘ 𝕨}¨ (⥊>𝕩)}˘ reduce_flags
hop_gather ← ⌽hop_reduce
gather_flags ← (↕nd) {(𝕨⊸{Flip⎉𝕨 𝕩})¨ 𝕩}˘ hop_gather
gcomb ← (hop_gather (⋈)˘¨˘ gather_flags)

dd ← >⋈⎉¯1 data

Wrapper ← {𝕊dd‿comb:
MkHop ← {𝕨𝕊hop_id:
  hop_d ← hop_id ⊏ comb
  data ← >𝕨
  ldata ← (¯1⊸⊏)˘ 𝕨
  SwRdc ← {sw_id𝕊𝕩:
    sw_d ← (sw_id ⊏ ldata)
    sw_f ← ⊑(sw_id ⊏ ⥊vars)
    Reduce ← {𝕨𝕊hop_f‿pkt_f:
      pkt_f2 ← (sw_f ≡ pkt_f)⊑(pkt_f‿(pkt_f≠pkt_f))
      hop_d ← ⊑(⥊hop_f) / (<˘ ldata)
      pkt_d ← ×⟜hop_d¨ sw_f‿pkt_f2
      +´ (⋈𝕨)∾pkt_d
    }
    Gather ← {𝕨𝕊hop_f‿pkt_f:
      hop_d ← ⊑(⥊hop_f) / (<˘ ldata)
      hol_f ← hop_f ∨ pkt_f
      pkt_holes ← hop_d×hol_f
      sw_holes ← ((¬hol_f)⊸×) 𝕨
      +´ sw_holes‿pkt_holes
    }
    flag2 ← ⌊⊑hop_id÷nd
    fn ← flag2⊑Reduce‿Gather
    outstep ← (<˘ sw_d) fn` (⋈˘ 𝕩)
    ∾˘outstep
  }
 (↕(≢hop_d)) SwRdc˘ (>hop_d)
}
out_r ← (⋈ dd) MkHop` (⋈˘ (↕(≠comb)))
}

rgcomb ← rcomb∾gcomb
out_r ← Wrapper dd‿rgcomb
out_list ← ∾˝ out_r
# num_sw x total_steps x mat
out_steps ← {𝕨 ∾˘ (>𝕩)}´ out_list
out_steps2 ← ((≍˘data) ∾˘ out_steps)
total_steps ← 1⊑(≢out_steps2)
duration ← (total_steps × secs_per_step)
out_grouped ← (<⎉2 out_steps2)
#gg ← (≍∘¯1⊸⊏)˘ (⊑¯1⊏out_r)

DrawRectangleLines ← {r‿g‿b‿a𝕊x‿y‿wx‿wy:
   raylib.DrawRectangleLines⟨x, y, wx, wy, r‿g‿b‿a⟩
   #raylib.DrawRectangleLines 𝕨∾⟜<˜(⌈∾⊢-⊏∘𝕩)(+˝÷≠)𝕩
}⎉1‿2

fontSize ← 20
clock ← r.StartClock@

PerFrame ← {𝕤
    elapsedSecs ← ⌈clock.Time@
    secs_idx ←  duration | elapsedSecs
    step_idx ← ⌊(secs_idx ÷ secs_per_step)
    sw_id ← 3

    pos ← r.mouse.GetPos@
    {white r.draw.EllipseOutline 𝕩}˘ ellipseGrid
    font ← r.font.LoadRaylib@
    {white DrawRectangleLines 𝕩}˘ out_lines
    {white DrawRectangleLines 𝕩}˘ aout_lines
    {white‿font‿fontSize r.draw.Text 𝕩}˘ out_txt
    aout_txt ← atext_pos FmtTxt (sw_id‿step_idx ⊑ out_grouped)
    {white‿font‿fontSize r.draw.Text 𝕩}˘ aout_txt
    {raylib.DrawSplineBezierCubic 𝕩∾4∾2.0⋈red}˘ curves
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "HyperX"
