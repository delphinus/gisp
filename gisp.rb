# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v0.0.5.tar.gz'
  sha256 'fd84badf0350c572d54c797136baea54c5ed1c64fd409dc8d82a606d80a47149'
  version '0.0.5'
  head 'https://github.com/delphinus/homebrew-gisp.git'

  service do
    run [bin / 'gisp', '-v']
    keep_alive true
    log_path "#{Dir.home}/Library/Logs/gisp.log"
    error_log_path "#{Dir.home}/Library/Logs/gisp_error.log"
  end

  def install
    inreplace 'gisp', /(?<=our \$VERSION = ').*(?=';)/, version.to_s
    bin.install 'gisp'
  end
end
