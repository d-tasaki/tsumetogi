require 'tsumetogi'
require 'yaml'

module Tsumetogi
  class Config
    attr_accessor :resolution
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    attr_accessor :images_dir
    attr_accessor :diff_strategy
    attr_accessor :verbose
    attr_accessor :progress
    attr_accessor :text
    attr_accessor :text_path

    DEFAULT_OPTIONS = {
      resolution: 150,
      crop_x: 0,
      crop_y: 0,
      crop_w: 0,
      crop_h: 0,
      diff_strategy: "Digest",
      verbose: false,
      progress: true,
      text: true,
    }

    def initialize(options = {})
      config_path = options[:config]
      if config_path
        config = YAML.load(File.read(config_path))
        config && config.each do |k, v|
          writer_method = "#{k}="
          if self.respond_to?(writer_method)
            self.send(writer_method, v) 
          else
            warn "Unknown config item found: #{k}"
          end
        end
      end

      # set option-specified or default values
      DEFAULT_OPTIONS.each do |k, v|
        self.send("#{k}=", options[k] || v) if instance_variable_get("@#{k}").nil?
      end
    end

    # get crop box with convert cm -> dots
    [:crop_x, :crop_y, :crop_w, :crop_h].each do |reader_name|
      define_method reader_name do
        n = instance_variable_get("@#{reader_name}")
        (n * self.resolution / 25.4).to_i
      end
    end

  end
end
