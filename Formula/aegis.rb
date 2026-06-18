class Aegis < Formula
  desc "Local agent-guard: stops prompt injection, jailbreaks & infra-impersonation against AI agents"
  homepage "https://github.com/pilot-protocol/aegis"
  version "0.1.1"
  license "MIT"

  # Prebuilt binaries — no compiler needed, installs in seconds.
  on_macos do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.1/aegis-macos-arm64"
      sha256 "fe9d7d49a60d244706decbb747a40cd16a4a45bb75c074bbf45684f49f61e167"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.1/aegis-linux-arm64"
      sha256 "abf2d39fbb74829ba2a793f90081aadf02a560795f5a54219819ba688bd3bf17"
    end
    on_intel do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.1/aegis-linux-x86_64"
      sha256 "b60a58d17d8b92947c9d24423ebfccff47c1adce1a08d4eaad9c7c9104ecbc91"
    end
  end

  # The local judge engine. AEGIS still runs (L1 patterns) without it.
  depends_on "llama.cpp"

  def install
    bin.install Dir["aegis*"].first => "aegis"
  end

  service do
    run [opt_bin/"aegis", "daemon"]
    keep_alive true
    log_path var/"log/aegis.log"
    error_log_path var/"log/aegis.log"
  end

  def caveats
    <<~EOS
      Download the judge model once (~1.8 GB):
        aegis install-models
      Then protect your agent surfaces:
        aegis init
        brew services start aegis     # or: aegis daemon
    EOS
  end

  test do
    assert_match "aegis #{version}", shell_output("#{bin}/aegis version")
  end
end
