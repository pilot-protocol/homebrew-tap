class Aegis < Formula
  desc "Local agent-guard: stops prompt injection, jailbreaks & infra-impersonation against AI agents"
  homepage "https://github.com/pilot-protocol/aegis"
  url "https://github.com/pilot-protocol/aegis/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d3d98c68261426c1f73e3924d8667f44f1c10249c82dd48eba23575c04fb2b33"
  license "MIT"
  head "https://github.com/pilot-protocol/aegis.git", branch: "main"

  depends_on "rust" => :build
  depends_on "llama.cpp"

  def install
    system "cargo", "install", *std_cargo_args
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
        aegis daemon          # or run it in the background:
        brew services start aegis
    EOS
  end

  test do
    assert_match "aegis #{version}", shell_output("#{bin}/aegis version")
  end
end
