class SquigitOcr < Formula
  desc "Standalone purely headless CLI OCR engine for Squigit"
  homepage "https://github.com/a7mddra/squigit"
  url "https://github.com/squigit-org/squigit/releases/download/ocr-v0.1.0/squigit-ocr-mac-aarch64.tar.gz"
  sha256 "356429d7b953be80f3b04dbae17febb40db69109f16e44590597ad8872d7f2cf"
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
