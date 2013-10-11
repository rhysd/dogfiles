# libraries
require 'awesome_print'

Pry.config.editor = 'vim'

# user defined commands
if RUBY_PLATFORM.include? 'darwin'
  def pbcopy(str)
    IO.popen('pbcopy', 'r+') {|io| io.puts str }
  end

  Pry.config.commands.command 'history2copy', 'Copy a history to clipboard' do |n|
    pbcopy _pry_.input_array[n ? n.to_i : -1]
  end

  Pry.config.commands.command 'result2copy', 'Copy the last result to clipboard' do
    pbcopy _pry_.last_result.chomp
  end
end

# aliases
alias :r :require

# vim: set ft=ruby:
