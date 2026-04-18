class SquigitOcr < Formula
  desc "Standalone purely headless CLI OCR engine for Squigit"
  homepage "https://github.com/a7mddra/squigit"
  url "https://github.com/a7mddra/squigit/releases/download/ocr-v0.1.1/squigit-ocr-mac-aarch64.tar.gz"
  sha256 "cda2692f2ad474cee6fe60757073c0ef8e6a679caab35c61a6c54c593ad35228"
  version "0.1.1"

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
