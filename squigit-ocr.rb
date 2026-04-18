class SquigitOcr < Formula
  desc "Standalone purely headless CLI OCR engine for Squigit"
  homepage "https://github.com/a7mddra/squigit"
  url "https://github.com/a7mddra/squigit/releases/download/ocr-v0.1.0/squigit-ocr-mac-aarch64.tar.gz"
  sha256 "457bca9db68a27ff0c4e8b32040dd6f8f4f23a3aab3304278ec9ccbdf7c66105"
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
