# Tsumetogi

```text
      ∧_∧
    ﾐ,・_・ﾐ にゃー
  ヾ(_ｕｕﾉ
```

Tsumetogi slices a pdf into images in order to show the differences between current and previous versions on a SCM tool (such as GitHub, BitBucket, etc).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tsumetogi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tsumetogi

## Dependency

Tsumetogi uses [ImageMagick](http://www.imagemagick.org/) and [Poppler](https://poppler.freedesktop.org/).

On Mac:

```bash
$ brew install imagemagick
$ brew install poppler
```

## Usage

```bash
$ bundle exec tsumetogi scratch pdf_path
```

Options:

* `--config=path`: path to a YAML-based config file
* `--diff_strategy=[Digest|HighAccuracy|LowMemory]`: specifies a strategy name to compare images between current and previous versions
    * `Digest`: compares images with MD5 digest. It is so fast and low memories, but low accuracy.
    * `HighAccuracy`: compares images with brightness average values of composed diff images. Its accuracy is high, but it consumes more memories.
    * `LowMemory`: compares images with brightness average values of composed diff images. Its accuracy is high, but so slow.
* `--image-dir=path`: path to a directory which will be outputed sliced images (default: <pdf_path>-images)
* `--resolution=N`: density of sliced images (unit is dpi)
* `--crop-x=N`, `--crop-y=N`, `--crop-w=N`, `--crop-h=N`: specifies a crop box (unit is cm). (e.g. to crop page numbers in the footer that chages frequently when you add some pages)
* `--text`, `--no-text`: outputs a text extracted from the pdf
* `--text_path=path`: path to a extracted text file (default: <pdf_path>.txt)
* `--progress`, `--no-progress`: shows progresses on stdout (default: true)
* `--verbose`, `--no-verbose`: shows debug messages on stdout (default: false)

Config file:

You can specifies these options mentioned above with a YAML-based config file.

e.g.

```yaml
resolution: 72
crop_x: 0
crop_y: 0
crop_w: 209.97 # cm
crop_h: 286.85 # cm
diff_strategy: HighAccuracy
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/devchick/tsumetogi.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

