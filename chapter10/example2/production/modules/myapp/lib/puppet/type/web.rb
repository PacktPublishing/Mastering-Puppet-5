Puppet::Type.newtype :web, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :port
  newparam :ip
end
