# -*- coding: utf-8 -*-
require 'tsumetogi'
require 'tsumetogi/diff_strategies/base'

# メモリ消費量すくなめ差分チェック
# @note 外部コマンドを呼び出して差分画像を生成し、その平均輝度値を取得します。消費メモリは少ないですが処理時間がかかります。
# @see http://blog.mirakui.com/entry/20110326/1301111196
module Tsumetogi
  module DiffStrategies
    class LowMemory < Base
      def initialize(config = nil)
        super
      end

      def difference(reference, target)
        diff_path = File.join(@tmp_dir, "diff.png")

        diff_cmd  = ["composite", "-compose", "difference"]
        diff_cmd << reference
        diff_cmd << target
        diff_cmd << diff_path
        system *diff_cmd

        id_cmd  = ["identify"]
        id_cmd += ["-format", "%[mean]"]
        id_cmd << diff_path
        diff = `#{id_cmd.join(" ")}`

        diff.chomp.to_f / 65535
      end

      def before_match
        @tmp_dir = Dir.mktmpdir
      end

      def after_match
        FileUtils.remove_entry_secure @tmp_dir
      end

    end
  end
end
