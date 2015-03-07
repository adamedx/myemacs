#
# Cookbook Name:: myemacs
# Recipe:: default
#
# Copyright (c) 2015 Adam Edwards, All Rights Reserved.

include_recipe 'git'

git_cache = "#{Chef::Config[:file_cache_path]}/myemacs/repos"

windows_suffix = Chef::Platform.windows? ? File.join('AppData', 'Roaming') : ''
emacs_config_directory = File.join("#{ENV['HOME']}", windows_suffix)


dot_emacs_root = "#{git_cache}/dot-emacs"
powershell_mode_root = "#{git_cache}/powershell.el"
markdown_mode_root = "#{git_cache}/markdown-mode"

git_sources = [
               ['https://github.com/adamedx/dot-emacs', dot_emacs_root],
               ['https://github.com/jschaf/powershell.el', powershell_mode_root],
               ['http://jblevins.org/git/markdown-mode.git', markdown_mode_root]
              ]


directory git_cache do
  recursive true
end


git_sources.each do | git_source |
  git git_source[1] do
    repository git_source[0]
    depth git_source[0].end_with?('.git') ? nil : 1
  end
end

windows_suffix = Chef::Platform.windows? ? ::File.join('AppData', 'Roaming') : ''
emacs_config_directory = ::File.join("#{ENV['HOME']}", windows_suffix)

emacs_managed_init_file = ::File.join(emacs_config_directory, '.emacs-managed')

file "#{emacs_managed_init_file}" do
  content IO.read(::File.join("#{dot_emacs_root}", '.emacs'))
end

emacs_custom_library_directory = ::File.join(emacs_config_directory,'.emacs-autoload')

directory emacs_custom_library_directory do
end

file "#{emacs_custom_library_directory}/powershell.el" do
  content IO.read(::File.join("#{powershell_mode_root}/powershell.el"))
end

file "#{emacs_custom_library_directory}/markdown-mode.el" do
  content IO.read(::File.join("#{markdown_mode_root}/markdown-mode.el"))
end

file "#{emacs_config_directory}/.emacs" do
  content <<-EOH
(add-to-list 'load-path "#{emacs_custom_library_directory}")
(load-library "#{emacs_managed_init_file}")
EOH
end


