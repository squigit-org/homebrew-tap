class SquigitStt < Formula
  desc "Standalone purely headless CLI STT engine for Squigit"
  homepage "https://github.com/squigit-org/squigit"
  url "https://github.com/squigit-org/squigit/releases/download/stt-v0.1.0/squigit-stt-mac-aarch64.tar.gz"
  sha256 "0ce0706317f9071dae682399c9b8bd8b3b20a5d96f0753f66e93376d4205354c"
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
