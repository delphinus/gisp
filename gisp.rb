# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v1.0.3.tar.gz'
  sha256 '1b3a2d3d46c8f68c817ec27398d5683b4e143614b1a9a26b1ca6cb27685949ab'
  version '1.0.3'
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
