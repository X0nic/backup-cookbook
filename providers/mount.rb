# Support whyrun
def whyrun_supported?
  true
end

action :enable do
  if node['backup']['server']['address'].nil?
    Chef::Log.warn("The backup.server.address attribute is not defined. Not taking any action")
  else
    directory new_resource.path do
      owner node['backup']['user']
      group node['backup']['group']
      mode '0700'
      recursive true
    end

    mount new_resource.path do
      fstype 'nfs'
      device device_name
      action [:mount, :enable]
    end
  end
end

action :disable do

  mount new_resource.path do
    device device_name
    action [:umount, :disable]
  end

  directory new_resource.path do
    action :delete
  end
end

private

def device_name
  "#{node['backup']['server']['address']}:/#{node['backup']['server']['root_path']}/#{new_resource.remote_path}"
end
