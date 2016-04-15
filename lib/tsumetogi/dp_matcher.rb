# -*- coding: utf-8 -*-
require 'tsumetogi'

module Tsumetogi
  class DpMatcher

    def initialize(references, targets, diff_strategy_name)
      @references = references
      @targets = targets
      @diff_strategy_name = diff_strategy_name
      diff_class = Tsumetogi::DiffStrategies.const_get(diff_strategy_name) rescue Tsumetogi::DiffStrategies::Digest
      @diff_strategy = diff_class.new
      @trellis = []
    end

    def match
      @diff_strategy.before_match

      total_num = @references.size * @targets.size
      processed_num = 0
      @references.each_with_index do |ref, ref_index|
        @diff_strategy.before_reference(ref, ref_index)
        @trellis << []
        @targets.each_with_index do |tar, tar_index|
          diff = @diff_strategy.difference(ref, tar)
          @trellis[ref_index] << minimize_distance(diff, ref_index, tar_index)
          processed_num += 1
          Tsumetogi.logger.progress "Matching with #{@diff_strategy_name}", processed_num, total_num
        end
        @diff_strategy.after_reference(ref, ref_index)
      end
      Tsumetogi.logger.puts

      self
    ensure
      @diff_strategy.after_match
    end

    def back_trace
      ref_index = @references.size - 1
      tar_index = @targets.size - 1
      trace = []

      loop do
        dist = trellis(ref_index, tar_index)
        break if dist.direct == :none
        trace << dist.direct

        case dist.direct
        when :modify, :nochange
          ref_index -= 1
          tar_index -= 1
        when :add
          tar_index -= 1
        when :remove
          ref_index -= 1
        end
      end

      trace.reverse
    end

    private

    # DP平面における距離と方向を表現する構造体
    Distance = Struct.new(:dist, :direct) do
      def <=>(other)
        self.dist <=> other.dist
      end
    end

    # 最短距離の選定
    # @note: 対象型傾斜制限を利用
    def minimize_distance(diff, ref_index, tar_index)
      candidates = []
      candidates << Distance.new(trellis(ref_index - 1, tar_index - 1).dist + diff, (diff == 0.0 ? :nochange : :modify))
      candidates << Distance.new(trellis(ref_index    , tar_index - 1).dist + diff, :add)
      candidates << Distance.new(trellis(ref_index - 1, tar_index    ).dist + diff, :remove)
      candidates.min
    end

    # DP平面における特定の位置の距離を取得
    def trellis(ref_index, tar_index)
      if ref_index.negative? && tar_index.negative?
        Distance.new(0, :none)
      elsif ref_index.negative?
        Distance.new(tar_index + 1, :add)
      elsif tar_index.negative?
        Distance.new(ref_index + 1, :remove)
      else
        @trellis[ref_index][tar_index]
      end
    end

  end
end
