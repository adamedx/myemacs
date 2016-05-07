#
# Cookbook Name:: myemacs
# Recipe:: default
#
# Copyright (c) 2015 Adam Edwards, All Rights Reserved.


use_git_recipe = true

if ! Chef::Platform.windows?
  git_result = `whereis git`
  use_git_recipe = ! git_result.start_with?('git: /')
  if use_git_recipe
    log 'Git not detected, will attempt installation';
  end
end

if use_git_recipe
  include_recipe 'git'
end

git_cache = "#{Chef::Config[:file_cache_path]}/myemacs/repos"

home_dir = Chef::Platform.windows? ? ENV['USERPROFILE'] : ENV['HOME']
if ::File::ALT_SEPARATOR
  home_dir = home_dir.gsub(::File::ALT_SEPARATOR, '/')
end

windows_suffix = Chef::Platform.windows? ? ::File.join('AppData', 'Roaming') : ''
emacs_config_directory = File.join(home_dir, windows_suffix)

if ::File::ALT_SEPARATOR
  emacs_config_directory = emacs_config_directory.gsub(::File::ALT_SEPARATOR, '/')
end

directory emacs_config_directory do
  only_if { Chef::Platform.windows? }
end

dot_emacs_root = "#{git_cache}/dot-emacs"
powershell_mode_root = "#{git_cache}/powershell.el"
markdown_mode_root = "#{git_cache}/markdown-mode"

git_sources = {
  dot_emacs_root => 'https://github.com/adamedx/dot-emacs',
  powershell_mode_root => 'https://github.com/jschaf/powershell.el',
  markdown_mode_root => 'http://jblevins.org/git/markdown-mode.git'
}

directory git_cache do
  recursive true
end

git_sources.each do | directory_name, repo_path |
  git directory_name do
    repository repo_path
    depth repo_path.end_with?('.git') ? nil : 1
  end
end

emacs_managed_init_file = ::File.join(emacs_config_directory, '.emacs-managed')

file "#{emacs_managed_init_file}" do
  content lazy { IO.read(::File.join("#{dot_emacs_root}", '.emacs')) }
end

emacs_custom_library_directory = ::File.join(emacs_config_directory,'.emacs-autoload')

directory emacs_custom_library_directory;

library_files = {
  'powershell.el' => powershell_mode_root,
  'markdown-mode.el' => markdown_mode_root
}

library_files.each do | library_name, library_source |
  file "#{emacs_custom_library_directory}/#{library_name}" do
    content lazy { IO.read(::File.join("#{library_source}/#{library_name}")) }
  end
end

legacy_config_directory = "#{home_dir}/.emacs.d"
directory legacy_config_directory;

[ "#{emacs_config_directory}/.emacs",
  "#{legacy_config_directory}/.init.el" ].each do | config_file |

  file "#{config_file}" do
    content <<-EOH
(add-to-list 'load-path "#{emacs_custom_library_directory}")
(load-library "#{emacs_managed_init_file}")
EOH
  end

end

