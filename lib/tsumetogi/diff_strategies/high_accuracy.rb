# -*- coding: utf-8 -*-
require 'tsumetogi'
require 'tsumetogi/diff_strategies/base'
require 'rmagick'
require 'tsumetogi/diff_strategies/base'

# 高精度差分チェック
# @note 画像間の差をとり平均輝度値を取得します。消費メモリは多いですがオンメモリで計算するので高速です。
module Tsumetogi
  module DiffStrategies
    class HighAccuracy < Base

      def difference(reference, target)
        @images[target] ||= Magick::Image.read(target).first
        ref = @images[reference]
        tar = @images[target]

        _, normalized_mean_error, _ = ref.difference(tar)
        normalized_mean_error
      end

      def before_match
        @images = {}
      end

      def after_match
        @images.each do |_, image|
          image.destroy! if image
        end
      end

      def before_reference(ref, index)
        @images[ref] ||= Magick::Image.read(ref).first
      end

      def after_reference(ref, index)
        @images[ref].destroy!
        @images[ref] = nil
      end

    end
  end
end
