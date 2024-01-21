# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v0.0.6.tar.gz'
  sha256 'eeb393c278693095d48ba6a9ee09e770d18478ab0eec70236ccafdc722671c02'
  version '0.0.6'
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
