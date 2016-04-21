# -*- coding: utf-8 -*-
require 'tsumetogi'
require 'thor'

module Tsumetogi
  class CLI < Thor
    package_name "tsumetogi"

    desc "scratch pdf_path", "slice a pdf into images"
    method_option :config,        type: :string, aliases: "-c"
    method_option :diff_strategy, type: :string
    method_option :image_dir,     type: :string
    method_option :resolution,    type: :numeric
    method_option :crop_x,        type: :numeric
    method_option :crop_y,        type: :numeric
    method_option :crop_w,        type: :numeric
    method_option :crop_h,        type: :numeric
    method_option :text,          type: :boolean
    method_option :text_path,     type: :string
    method_option :progress,      type: :boolean
    method_option :verbose,       type: :boolean
    def scratch(pdf_path)
      config = Tsumetogi::Config.new(options)
      Tsumetogi.logger = Tsumetogi::Logger.new(config)
      Scratcher.new(pdf_path, config).scratch
      TextExtractor.new(pdf_path, config).extract if config.text
    end

    desc "mew", "mew"
    def mew
      puts "    ∧_∧        "
      puts "  ﾐ,・_・ﾐ にゃー"
      puts "ヾ(_ｕｕﾉ        "
    end

  end
end
