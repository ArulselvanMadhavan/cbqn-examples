⟨SaveNpy⟩←•Import"npy.bqn"
Numel ← ↕×´
Mat ← ⥊⟜Numel
Enumerate ← (∾⌜)´∘(↕¨)
Zeros ← ⥊⟜0
dims ← 4‿4
dims_enum ← ⥊Enumerate dims
switches ← Mat dims
IdToDim ← ⊑∘(/⟜dims_enum)∘(⥊∘⍷˜)
GenNeighbors ← {𝕨𝕊𝕩:
neigh_idxs ← 𝕨
dim_id ← 𝕩
InsertDim ← {𝕨𝕊𝕩:
𝕩⌾(𝕨⊸⊑) dim_id
}
GenDimExclude ← /∘≠⟜↕
DimVariants ← {𝕊𝕩:
dim_idx ← 𝕩
dim_len‿dim_val ← dim_idx⊸⊑¨ dims‿dim_id
d3 ← dim_val GenDimExclude dim_len
dim_idx InsertDim¨ d3
}
neigh_ids ← ∾DimVariants¨ neigh_idxs
ns←dims_enum ⊸⊐⊢¨ neigh_ids
⥊switches ∊ ns
}
MakeNeighbors ← {𝕊𝕩:
>∘(𝕩⊸GenNeighbors∘IdToDim˜⟜switches¨) ⥊switches
}
hop_table ← >∘MakeNeighbors∘≍¨ (↕≠dims)
connections ← +´ hop_table

"hyperx_hops.npy" SaveNpy (¯1×∾hop_table)
"hyperx_conns.npy" SaveNpy (¯1×connections)
