# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v1.0.0.tar.gz'
  sha256 'cab1ccc3fe31d2f207ed6de5bf3dec94315d1b37d34e42708b0a11bdfa05c9d9'
  version '1.0.0'
  head 'https://github.com/delphinus/homebrew-gisp.git'

  service do
    run macos: [bin / 'gisp', '-v']
    keep_alive true
    log_path "#{Dir.home}/Library/Logs/gisp.log"
    error_log_path "#{Dir.home}/Library/Logs/gisp_error.log"
    sockets 'tcp://127.0.0.1:55100'
  end

  def install
    inreplace 'gisp', /(?<=our \$VERSION = ').*(?=';)/, version.to_s
    bin.install 'gisp'
  end
end
