# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v1.0.5.tar.gz'
  sha256 '554dad43724dea4c8a93682e03e34cd366d951b5d3d23b1bed62e93d540f85ab'
  version '1.0.5'
  head 'https://github.com/delphinus/homebrew-gisp.git'

  service do
    run macos: [bin / 'gisp']
    keep_alive true
    error_log_path "#{Dir.home}/Library/Logs/gisp_error.log"
  end

  def install
    inreplace 'gisp', /(?<=our \$VERSION = ').*(?=';)/, version.to_s
    bin.install 'gisp'
    man1.install 'gisp.1'
  end
end
