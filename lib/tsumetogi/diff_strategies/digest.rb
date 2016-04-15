# -*- coding: utf-8 -*-
require 'tsumetogi'
require 'tsumetogi/diff_strategies/base'
require 'digest/md5'

# ダイジェスト差分チェック
# @note 画像ファイルのダイジェスト値で差分有無を判断します。メモリ消費も少なく高速ですが精度は良くありません。
module Tsumetogi
  module DiffStrategies
    class Digest < Base
      def difference(reference, target)
        @digests[reference] ||= ::Digest::MD5.file(reference).hexdigest
        @digests[target]    ||= ::Digest::MD5.file(target).hexdigest
        @digests[reference] == @digests[target] ? 0 : 1
      end

      def before_match
        @digests = {}
      end

    end
  end
end
