
parallel -j1 "conjure solve gen.essence --solver-options -randomiseorder ; mv gen.solution random{}.param" ::: $(seq -w 1 100)
