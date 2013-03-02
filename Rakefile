require 'fileutils'
include FileUtils

home = File.expand_path '~'

def cmd_exists? cmd
  paths = ENV['PATH'].split(':').uniq
  paths.any? do |path|
    p = "#{path}/#{cmd}"
    File.exists?(p) && File.executable?(p)
  end
end


def installed?(name)
  unless cmd_exists? name
    puts "#{name} is not installed. task is skipped."
    false
  else
    true
  end
end

namespace :common do
  task :all => [:git, :vim, :gem, :zsh]

  task :git do
    next unless installed? 'git'
    ln_s 'gitconfig', "#{home}/.gitconfig"
    ln_s 'global.gitignore', "#{home}/.gitignore"
  end

  task :vim do
    next unless installed? 'vim'
    %w( vimrc gvimrc vimshrc ).each do |f|
      ln_s f, "#{home}/.#{f}"
    end
    unless directory? "#{home}/.vim"
      mkdir "#{home}/.vim"
      mkdir "#{home}/.vim/bundle"
      mkdir "#{home}/.vim/undo"
    end

    next unless installed? 'git'
    chdir "#{home}/.vim/bundle" do
      `git clone git://github.com/Shougo/neobundle.vim.git`
    end
  end

  task :gem do
    next unless installed? 'gem'
    %w( gemrc pryrc ).each do |f|
      ln_s f, "#{home}/.#{f}"
    end

    `gem install pry pry-coolline pry-debugger pry-doc active_support`
  end

  task :zsh do
    next unless installed? 'zsh'
    ln_s 'zshrc', "#{home}/.zshrc"

    unless directory? "#{home}/.zsh"
      mkdir "#{home}/.zsh"
      mkdir "#{home}/.zsh/plugins"
      mkdir "#{home}/.zsh/site-functions"
    end

    next unless installed? 'git'
    chdir "#{home}/.zsh/plugins" do
      `git clone git://github.com/zsh-users/zaw.git`
      `git clone git://github.com/zsh-users/zsh-syntax-highlighting.git`
    end
  end
end

namespace :linux do
  desc 'set up dotfiles for Linux'
  task :setup => ['common:all', :tmux, :vim, :zsh, :xmodmap, :awesome, :conky]

  task :tmux do
    next unless installed? 'tmux'
    ln_s 'arch.tmux.conf', "#{home}/.tmux.conf"
  end

  task :vim do
    next unless installed? 'vim'
    %w( linux.vimrc linux.gvimrc ).each do |vimrc|
      ln_s vimrc, "#{home}/.#{vimrc}"
    end
  end

  task :zsh do
    next unless installed? 'zsh'
    ln_s 'linux.zsh', "#{home}/.linux.zsh"
  end

  task :xmodmap do
    next unless installed? 'xmodmap'
    ln_s 'Xmodmap', "#{home}/.Xmodmap"
  end

  task :awesome do
    next unless installed? 'awesome'
    unless directory? "#{home}/.config/awesome"
      mkdir_p "#{home}/.config/awesome"
    end
    ln_s 'rc.lua', "#{home}/.config/awesome/rc.lua"
  end

  task :conky do
    next unless installed? 'conky'
    ln_s 'conkyrc', "#{home}/.conkyrc"
  end
end

namespace :mac do
  desc 'set up dotfiles for Mac OS X'
  task :setup => ['common:all', :vim, :zsh, :tmux]

  task :vim do
    next unless installed? 'vim'
    %w( mac.vimrc mac.gvimrc ).each do |vimrc|
      ln_s vimrc, "#{home}/.#{vimrc}"
    end
  end

  task :zsh do
    next unless installed? 'zsh'
    ln_s 'mac.zsh', "#{home}/.mac.zsh"
  end

  task :tmux do
    next unless installed? 'tmux'
    ln_s 'mac.tmux.conf', "#{home}/.tmux.conf"
  end

end

require "rbconfig"
os = RbConfig::CONFIG["target_os"].downcase
case os
when /mswin(?!ce)|mingw|cygwin|bccwin/
  raise 'Windows is not supported'
when /linux/
  desc 'set up dotfiles (platform is guessed)'
  task :setup => ['linux:setup']
when /darwin/
  desc 'set up dotfiles (platform is guessed)'
  task :setup => ['linux:mac']
else
  raise 'Unknown platform'
end
