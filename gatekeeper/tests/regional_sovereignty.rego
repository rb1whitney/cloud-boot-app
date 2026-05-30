package regionalsovereignty

violation contains {"msg": msg} if {
  region := input.review.object.metadata.annotations["cloud-boot-app.io/region"]
  not is_allowed(region, input.parameters.allowed_regions)
  msg := sprintf("Region %v is not authorized. Allowed regions: %v", [region, input.parameters.allowed_regions])
}

is_allowed(region, allowed_regions) if {
  region == allowed_regions[_]
}
