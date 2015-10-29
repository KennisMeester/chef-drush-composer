#
# Cookbook Name:: chef-drush-composer
# Recipe:: default
#
# Copyright 2015, KennisMeester.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'composer'

drush_dir = "#{Chef::Config[:file_cache_path]}/drush_composer"

directory drush_dir do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

# Set the version flag.
if node['drush_composer']['version'] != 'latest'
  version = node['drush_composer']['version']
else
  version = '*.*.*'
end

# Copy the template.
template "#{drush_dir}/composer.json" do
  source 'composer.json.erb'
  owner 'root'
  group 'root'
  mode 0600
  variables(
    :version => version
  )
end

# Update composer.
execute 'drush-composer' do
  user 'root'
  cwd drush_dir
  command 'composer update'
  action :run
end
