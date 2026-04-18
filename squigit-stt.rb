class SquigitStt < Formula
  desc "Standalone purely headless CLI STT engine for Squigit"
  homepage "https://github.com/squigit-org/squigit"
  url "https://github.com/squigit-org/squigit/releases/download/stt-v0.1.0/squigit-stt-mac-aarch64.tar.gz"
  sha256 "de5b83aef5abb71c1b3bd2afdf93af7cc15488bfa915cef88fee56177b0bd28e"
  version "0.1.0"

  def install
    unless OS.mac? && Hardware::CPU.arm?
      odie "squigit-stt currently supports macOS arm64 (Apple Silicon) only."
    end

    bin.install "squigit-stt" => "squigit-stt"
    (share/"squigit-stt/models").install Dir["models/*"] if Dir.exist?("models")
    (bin/"_internal").install Dir["_internal/*"] if Dir.exist?("_internal")
  end

  test do
    system "#{bin}/squigit-stt", "--version"
  end
end
