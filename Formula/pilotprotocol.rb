class Pilotprotocol < Formula
  desc "Network stack for AI agents - addresses, ports, tunnels, encryption, trust"
  homepage "https://pilotprotocol.network"
  version "1.13.7"
  license "AGPL-3.0-or-later"

  # Prebuilt binaries — no Go toolchain needed, installs in seconds.
  on_macos do
    on_arm do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.7/pilot-darwin-arm64.tar.gz"
      sha256 "fd40750bd53c06ae6306d6945580e8dbf6f9e9393ff549bbb4269a2be02cfcf5"
    end
    on_intel do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.7/pilot-darwin-amd64.tar.gz"
      sha256 "8210cf4ca5532fb6d350ae532d7cd58fb9716e514617eaa59a9faf2b1560ff9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.7/pilot-linux-arm64.tar.gz"
      sha256 "5a5e2d2eb6fed41274cd00794a180082056f68d2469de91366c46ae7fb3ed800"
    end
    on_intel do
      url "https://github.com/pilot-protocol/pilotprotocol/releases/download/v1.13.7/pilot-linux-amd64.tar.gz"
      sha256 "3466f78b0be04e571910a2bd46b81dcf59503472b868ca2f6450f8173bb8fced"
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

  # Homebrew runs post_install with HOME pointed at a throwaway sandbox
  # directory, so anything written to ~/.pilot here is silently discarded.
  # The inherited formula wrote ~/.pilot/config.json (and a .pilot-version
  # marker) from post_install and then told the user in caveats that it had
  # done so — neither ever landed on disk. Only Homebrew-owned paths are
  # touched here; user config is left to `pilotctl`, with an explicit recipe
  # in caveats for anyone who wants to pin the endpoints by hand.
  def post_install
    (var/"pilot").mkpath
    (var/"log").mkpath
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
