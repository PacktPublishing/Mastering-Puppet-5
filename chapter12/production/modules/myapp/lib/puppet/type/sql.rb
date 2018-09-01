Puppet::Type.newtype :sql, :is_capability => true do
  newparam :name, :namevar => true
  newparam :dbname
  newparam :dbhost
  newparam :dbpass
  newparam :dbuser
end
