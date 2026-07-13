class Aegis < Formula
  desc "Local agent-guard: stops prompt injection, jailbreaks & infra-impersonation against AI agents"
  homepage "https://github.com/pilot-protocol/aegis"
  version "0.1.4"
  license "MIT"

  # Prebuilt binaries — no compiler needed, installs in seconds.
  on_macos do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.4/aegis-macos-arm64"
      sha256 "ef3e215f5459e7ca7bc98fb914c93ae171129c7fd6d267e3e9694c1c033277be"
    end
    on_intel do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.4/aegis-macos-x86_64"
      sha256 "15af99633ac3453f567d22bc29762ee5ec28b49f981f5216adfa933492ab1054"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.4/aegis-linux-arm64"
      sha256 "2b6c8e6d47ff319d9d5c36c50007a10a9cbecbfe54dd007913184510e5d2c15f"
    end
    on_intel do
      url "https://github.com/pilot-protocol/aegis/releases/download/v0.1.4/aegis-linux-x86_64"
      sha256 "ca6c0eba667b1689c0d3c7936131066ca8acee935bc03288d35797972b020f6d"
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
