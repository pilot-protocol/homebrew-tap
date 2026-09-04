class Pilotprotocol < Formula
  desc "Network stack for AI agents - addresses, ports, tunnels, encryption, trust"
  homepage "https://pilotprotocol.network"
  version "1.13.9"
  license "AGPL-3.0-or-later"

  # Prebuilt binaries — no Go toolchain needed, installs in seconds.
  on_macos do
    on_arm do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.9/pilot-darwin-arm64.tar.gz"
      sha256 "5dcd964af56bc362c51f663948f7a728e0259e80efc06eb6b0985f70eb2e17fa"
    end
    on_intel do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.9/pilot-darwin-amd64.tar.gz"
      sha256 "18b26c0e19370871894165711c51c44e372ba87210ef95da7a705154f1e108e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.9/pilot-linux-arm64.tar.gz"
      sha256 "a07c7f7592bd9f26441c36539717eb5bd14e755d23bfbe3ec45aaaca8c1f52af"
    end
    on_intel do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.9/pilot-linux-amd64.tar.gz"
      sha256 "2f2366157ad1124a384904050c42084ff06d14df668a8e9f69eaa38b1e00fb45"
    end
  end

  # The release tarballs ship exactly three binaries: daemon, pilotctl,
  # updater. An earlier revision of this formula also did
  #   bin.install "gateway" => "pilot-gateway"
  # which fails outright, because the gateway repo is still a library with no
  # ./cmd/gateway to build. Install what the tarball actually contains.
  def install
    bin.install "daemon"   => "pilot-daemon"
    bin.install "pilotctl" => "pilotctl"
    bin.install "updater"  => "pilot-updater"
  end

  def caveats
    <<~EOS
      Get started:
        pilotctl daemon start --hostname my-agent --email you@example.com
        pilotctl info

      The daemon falls back to its built-in endpoints when no config is
      present. To pin them to DNS instead of the baked-in address:

        mkdir -p ~/.pilot && cat > ~/.pilot/config.json <<'JSON'
        {
          "registry": "registry.pilotprotocol.network:9000",
          "beacon": "beacon.pilotprotocol.network:9001",
          "socket": "/tmp/pilot.sock",
          "encrypt": true,
          "identity": "#{Dir.home}/.pilot/identity.json"
        }
        JSON

      Docs: https://pilotprotocol.network/docs

      To run the daemon as a background service:
        brew services start pilotprotocol
    EOS
  end

  service do
    run [
      opt_bin/"pilot-daemon",
      "-registry", "registry.pilotprotocol.network:9000",
      "-beacon", "beacon.pilotprotocol.network:9001",
      "-listen", ":4000",
      "-socket", "/tmp/pilot.sock",
      "-identity", "#{Dir.home}/.pilot/identity.json",
      "-encrypt"
    ]
    keep_alive crashed: true
    log_path var/"log/pilot-daemon.log"
    error_log_path var/"log/pilot-daemon.log"
  end

  test do
    assert_match "pilotctl", shell_output("#{bin}/pilotctl --help 2>&1")
    assert_match version.to_s, shell_output("#{bin}/pilotctl version 2>&1")
  end
end
