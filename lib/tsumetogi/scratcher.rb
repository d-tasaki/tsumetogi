require 'tsumetogi'

module Tsumetogi
  class Scratcher

    def initialize(pdf_path, config = nil)
      @pdf_path = pdf_path
      @config = config || Tsumetogi::Config.new
      @images_dir = @config.images_dir
      @images_dir ||= "#{File.dirname(@pdf_path)}/#{File.basename(@pdf_path, ".*")}-images"
    end

    def scratch
      tmp_dir = Dir.mktmpdir
      Tsumetogi.logger.debug "scratching #{File.basename(@pdf_path)} into #{tmp_dir}"

      references = fetch_reference_images(@images_dir)
      targets = slice_pages(tmp_dir)
      matcher = DpMatcher.new(references, targets, @config.diff_strategy).match

      ref_pages = scan_reference_pages(references)
      tar_pages = assign_target_pages(matcher.back_trace, ref_pages)

      if File.exists?(@images_dir)
        timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
        backup_dir = "#{@images_dir}_#{timestamp}.bak"
        FileUtils.move(@images_dir, backup_dir)
      end

      move_images(targets, tar_pages, @images_dir)

    ensure
      FileUtils.remove_entry_secure tmp_dir
    end

    private

    def fetch_reference_images(dir)
      return [] unless File.exist?(dir)

      Dir.glob("#{dir}/*.png").sort
    end

    def slice_pages(tmp_dir)
      crop_options = []
      unless [@config.crop_x, @config.crop_y, @config.crop_w, @config.crop_h].all?(&:zero?)
        crop_options += ["-x", (@config.crop_x * @config.resolution / 25.4).to_i.to_s] # convert cm -> dot
        crop_options += ["-y", (@config.crop_y * @config.resolution / 25.4).to_i.to_s]
        crop_options += ["-W", (@config.crop_w * @config.resolution / 25.4).to_i.to_s]
        crop_options += ["-H", (@config.crop_h * @config.resolution / 25.4).to_i.to_s]
      end

      cmd = ["pdftoppm", "-png"]
      cmd += ["-r", @config.resolution.to_s]
      cmd += crop_options
      cmd += [@pdf_path, File.join(tmp_dir, "page")]
      Tsumetogi.logger.debug cmd.join(" ")
      system *cmd

      Dir.glob("#{tmp_dir}/*.png")
    end

    def scan_reference_pages(refereces)
      pages = refereces.map do |path|
        m = File.basename(path).match(/page_([0-9a-f_]+)/i)
        Tsumetogi::PageNum.new(m[1]) if m
      end
      pages.compact!
      pages
    end

    def assign_target_pages(traces, ref_pages)
      Tsumetogi.logger.debug traces.inspect
      traces = traces.dup
      ref_pages = ref_pages.dup
      prev_page = Tsumetogi::PageNum.new

      pages = []
      add_pages_num = 0
      
      while(traces.size.nonzero?) do
        case traces.shift
        when :modify, :nochange
          crnt_page = ref_pages.shift || Tsumetogi::PageNum::Infinity
          if add_pages_num.nonzero?
            pages += Tsumetogi::PageNum.lerp(prev_page, crnt_page, add_pages_num)
            add_pages_num = 0
          end
          pages << crnt_page
          prev_page = crnt_page

        when :add
          add_pages_num += 1

        when :remove
          ref_pages.shift
        end
      end

      if add_pages_num.nonzero?
        pages += Tsumetogi::PageNum.lerp(prev_page, Tsumetogi::PageNum::Infinity, add_pages_num)
      end

      pages
    end

    def move_images(targets, pages, dir)
      FileUtils.mkpath(dir) unless File.exists?(dir)

      targets.zip(pages).each do |target, page|
        path = File.join(dir, "page_#{page}.png")
        FileUtils.move(target, path)
      end
    end

  end
end
