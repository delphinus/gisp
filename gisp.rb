# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v1.0.1.tar.gz'
  sha256 'b96af03ad1ab1e95b57beb87c5b713dc5587ef45b3e3b71da8bda75108bf3828'
  version '1.0.1'
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
