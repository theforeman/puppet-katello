# @summary A boolean that also accepts empty strings
# In Hiera the function alias() returns an empty string if the value is undefined.
type Katello::HieraBoolean = Variant[Boolean, Enum['']]
