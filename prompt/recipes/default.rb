#
# Add stack name to prompt.
#

template "/etc/profile.d/ps1.sh" do
  source "ps1.sh.erb"
  mode 0644
  user 'root'
  group 'root'
end

