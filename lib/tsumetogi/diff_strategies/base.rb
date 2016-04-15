# -*- coding: utf-8 -*-
require 'tsumetogi'

module Tsumetogi
  module DiffStrategies
    class Base
      def initialize(config = nil)
        @config = config
puts "DiffStrategy: #{self.class}"
      end

      # 2つの画像ファイルの差分を計算
      # @param [String] reference 参照画像ファイルパス
      # @param [String] target ターゲット画像ファイルパス
      # @return [Numeric] 差分度合いを0〜1の数値で返す
      def difference(reference, target)
        raise "Override me!"
      end

      # マッチング処理開始前に1回呼び出されるコールバックメソッド
      def before_match
      end

      # マッチング処理完了後に1回呼び出されるコールバックメソッド
      def after_match
      end

      def before_reference(ref, index)
      end

      def after_reference(ref, index)
      end

    end
  end
end
