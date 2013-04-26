require 'rubygems' unless defined? Gem
require "logger"
require "fileutils"
require "awesome_print"
require "zucker/os"

class ZLogger < Logger

  def initialize(logfile=nil)
    unless logfile
      if ::OS.mac?
        logfile = File.expand_path('~/Library/Logs/vim/GoldenView.log')
      else
        logfile = File.expand_path('/var/log/vim/GoldenView.log')
      end
    end

    log_dir = File.dirname(logfile)
    FileUtils.mkdir_p log_dir unless File.exists? log_dir

    super logfile, 'weekly', 1048576
  end


end

