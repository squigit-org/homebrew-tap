class SquigitOcr < Formula
  desc "Standalone purely headless CLI OCR engine for Squigit"
  homepage "https://github.com/squigit-org/squigit"
  # Source template: release CI copies this file into the tap repo, then fills metadata via pkg.rb.
  url "https://github.com/squigit-org/squigit/releases/download/ocr-v0.1.0/squigit-ocr-mac-aarch64.tar.gz"
  sha256 "d8c9d7959c52bbe9312512a20f842ff35fb1ca055abab33f675c368b45e2314d"
  version "0.1.0"

  def install
    unless OS.mac? && Hardware::CPU.arm?
      odie "squigit-ocr currently supports macOS arm64 (Apple Silicon) only."
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"squigit-ocr"
  end

  test do
    system "#{bin}/squigit-ocr", "--help"
    system "#{bin}/squigit-ocr", "--version"
  end
end
