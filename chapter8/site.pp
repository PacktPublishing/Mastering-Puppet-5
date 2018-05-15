node 'test.node' {
  include relevant_role_or_profile
  include new_feature
}

# Notice the lack of a node group around the include statement
include $::classification
