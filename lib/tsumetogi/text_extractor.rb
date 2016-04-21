require 'tsumetogi'

module Tsumetogi
  class TextExtractor
    def initialize(pdf_path, config = nil)
      @pdf_path = pdf_path
      @config = config || Tsumetogi::Config.new
      @text_path = @config.text_path
      @text_path ||= "#{File.dirname(@pdf_path)}/#{File.basename(@pdf_path, ".*")}.txt"
    end

    def extract
      crop_options = []
      unless [@config.crop_x, @config.crop_y, @config.crop_w, @config.crop_h].all?(&:zero?)
        crop_options += ["-x", @config.crop_x.to_s]
        crop_options += ["-y", @config.crop_y.to_s]
        crop_options += ["-W", @config.crop_w.to_s]
        crop_options += ["-H", @config.crop_h.to_s]
      end

      cmd = ["pdftotext"]
      cmd += ["-r", @config.resolution.to_s]
      cmd += crop_options
      cmd += [@pdf_path, @text_path]

      Tsumetogi.logger.debug cmd.join(" ")
      system *cmd
    end
    
  end
end
