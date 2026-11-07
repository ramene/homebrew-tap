class RemoteSessions < Formula
  desc "Drive and record Claude Code Remote Control sessions"
  homepage "https://github.com/ramene/remote-sessions"
  license "MIT"

  release = "0.2.1"
  base = "https://github.com/ramene/remote-sessions/releases/download/remote-sessions-v#{release}"

  if OS.mac?
    url "#{base}/remote-sessions-#{release}-macos-universal.tar.gz"
    sha256 "87e28ceed53463fce328ab81b970f69f8a381acced6b71a155d1ec5b70fb76a0"
  elsif Hardware::CPU.arm?
    url "#{base}/remote-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "6b341aeed2c2fa33a00bea522e4d9d1baf89f8ea1b66a41f3daee9b1de4a0113"
  else
    url "#{base}/remote-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "c80365d5ebd8e41b925b095d5ad9375480f0d75ea8ae4cf0f7356387b8b3eeeb"
  end

  def install
    bin.install "remote-sessions"
    pkgshare.install "plugin"
  end

  def caveats
    <<~EOS
      remote-sessions drives Claude Code Remote Control sessions that run on your own machines.
      It needs the claude command on PATH and a claude.ai subscription login.
      Start a session on the machine that should run it:
        claude remote-control --name <n>
      or let remote-sessions check first and start it for you:
        remote-sessions serve --name <n> --check
        remote-sessions serve --name <n>
      Then, from any machine with your login (add --host <ssh-host> for another machine):
        remote-sessions list
        remote-sessions send <session id> --message "..."
      Recordings API (asciicast v2 casts, web player, mp4):
        remote-sessions cast <session uuid> --out session.cast
        remote-sessions recordings list
        remote-sessions recordings serve    # 127.0.0.1:3790, token in ~/.config/remote-sessions/recordings.token
      Claude Code plugin that came with this formula:
        claude --plugin-dir #{opt_pkgshare}/plugin
    EOS
  end

  test do
    assert_match "remote-sessions", shell_output("#{bin}/remote-sessions --help 2>&1")
  end
end
