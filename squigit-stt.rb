class SquigitStt < Formula
  desc "Standalone purely headless CLI STT engine for Squigit"
  homepage "https://github.com/squigit-org/squigit"
  # Source template: release CI copies this file into the tap repo, then fills metadata via pkg.rb.
  url "https://github.com/squigit-org/squigit/releases/download/stt-v0.1.0/squigit-stt-mac-aarch64.tar.gz"
  sha256 "2a09aa064f6f6cb73761c4813cd57f2bd8a04acb96fc2af5d61d94a0720f39eb"
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
    system "#{bin}/squigit-stt", "--help"
    system "#{bin}/squigit-stt", "--version"
  end
end
