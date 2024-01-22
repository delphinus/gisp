# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v1.0.2.tar.gz'
  sha256 '0bf75032b0d3415d3bbf562e6982a505f0bc24f41f1979022163168a7143c265'
  version '1.0.2'
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
