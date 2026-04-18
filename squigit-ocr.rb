class SquigitOcr < Formula
  desc "Standalone purely headless CLI OCR engine for Squigit"
  homepage "https://github.com/squigit-org/squigit"
  # Source template: release CI copies this file into the tap repo, then fills metadata via pkg.rb.
  url "https://github.com/squigit-org/squigit/releases/download/ocr-v0.1.0/squigit-ocr-mac-aarch64.tar.gz"
  sha256 "9fd97f7e36b3afa0e76387a1515d985c69d40b003a3ee8c164ab8b1ade6e50aa"
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
