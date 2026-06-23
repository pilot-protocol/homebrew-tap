class Aegis < Formula
  desc "Local agent-guard: stops prompt injection, jailbreaks & infra-impersonation against AI agents"
  homepage "https://github.com/pilot-protocol/aegis"
  version "0.1.3"
  license "MIT"

  # Prebuilt binaries — no compiler needed, installs in seconds.
  on_macos do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.3/aegis-macos-arm64"
      sha256 "2fe912bca87278fe54394d93bbda47e41d95b7c821010fc540bf585d0e7f5061"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.3/aegis-linux-arm64"
      sha256 "PLACEHOLDER_linux_arm64"
    end
    on_intel do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.3/aegis-linux-x86_64"
      sha256 "PLACEHOLDER_linux_x86_64"
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

      Protect your agent surfaces:
        aegis init
        brew services start aegis     # or: aegis daemon

      Wire into Claude Code as a blocking hook:
        aegis install-hooks

      When AEGIS blocks a command, approve it once with:
        aegis approve '<command>'
    EOS
  end

  test do
    assert_match "aegis #{version}", shell_output("#{bin}/aegis version")
  end
end
