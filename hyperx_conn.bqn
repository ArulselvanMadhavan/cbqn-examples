⟨SaveNpy⟩←•Import"npy.bqn"
Numel ← ↕×´
Mat ← ⥊⟜Numel
Enumerate ← (∾⌜)´∘(↕¨)
Zeros ← ⥊⟜0
dims ← 4‿4
dims_enum ← ⥊Enumerate dims
switches ← Mat dims
IdToDim ← ⊑∘(/⟜dims_enum)∘(⥊∘⍷˜)
GenNeighbors ← {𝕊𝕩:
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
neigh_ids ← ∾DimVariants¨↕≠dims
ns←dims_enum ⊸⊐⊢¨ neigh_ids
⥊switches ∊ ns
}
result ← GenNeighbors∘IdToDim˜⟜switches¨ ⥊switches
conn_table ← >result
"hyperx_conn.npy" SaveNpy (¯1×conn_table)
