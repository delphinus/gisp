# frozen_string_literal: true

# Formula to install the font: Gisp
class Gisp < Formula
  desc 'Google IME for SKK'
  homepage 'https://github.com/delphinus/homebrew-gisp'
  url 'https://github.com/delphinus/homebrew-gisp/archive/v0.0.4.tar.gz'
  sha256 '2648b7c07089454ef19437a351667183dd231b1b89a8bee1c760af877bfdb3ee'
  version '0.0.4'
  head 'https://github.com/delphinus/homebrew-gisp.git'

  service do
    run bin / 'gisp', '-v'
    keeyalive true
    log_path "#{Dir.home}/Library/Logs/gisp.log"
    error_log_path "#{Dir.home}/Library/Logs/gisp_error.log"
  end

  def install
    bin.install 'gisp'
  end
end
