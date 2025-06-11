#rotations

# uorrelated factors
# obl = Factors are allowed to correlate.
efa_between <- fa(between_test, nfactors = 2, rotate = "oblimin", fm = "ml")
print(efa_between, digits = 2, sort = TRUE)

efa_within  <- fa(within_test,  nfactors = 2, rotate = "oblimin", fm = "ml")
print(efa_within, digits = 2, sort = TRUE)

# uncorrelated factors
# orth = Factors are uncorrelated.
efa_between <- fa(between_test, nfactors = 2, rotate = "varimax", fm = "ml")
efa_within  <- fa(within_test,  nfactors = 2, rotate = "varimax", fm = "ml")
