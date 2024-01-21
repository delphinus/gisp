# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v0.0.3.tar.gz'
  sha256 'b4b91a8359c9fa7412b8688ef9dd2ceb645cb0cadb0f9a8bf952e093665d268c'
  version '0.0.3'
  head 'https://github.com/delphinus/homebrew-gisp.git'

  def install
    bin.install 'gisp'
  end
end
