# -*- coding: utf-8 -*-
require 'tsumetogi'
require 'thor'

module Tsumetogi
  class CLI < Thor
    package_name "tsumetogi"

    desc "scratch pdf_path", "slice a pdf into images"
    method_option :config,   type: :string, aliases: "-c"
    method_option :verbose,  type: :boolean
    method_option :progress, type: :boolean
    def scratch(pdf_path)
      config = Tsumetogi::Config.new(options)
      Tsumetogi.logger = Tsumetogi::Logger.new(config)
      s = Scratcher.new(pdf_path, config)
      s.scratch
    end

    desc "mew", "mew"
    def mew
      puts "    ∧_∧        "
      puts "  ﾐ,・_・ﾐ にゃー"
      puts "ヾ(_ｕｕﾉ        "
    end

  end
end
