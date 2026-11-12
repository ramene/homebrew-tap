class RemoteSessions < Formula
  desc "Drive and record Claude Code Remote Control sessions"
  homepage "https://github.com/ramene/remote-sessions"
  license "MIT"

  release = "0.3.1"
  base = "https://github.com/ramene/remote-sessions/releases/download/remote-sessions-v#{release}"

  if OS.mac?
    url "#{base}/remote-sessions-#{release}-macos-universal.tar.gz"
    sha256 "90a391f984f2e0983788091ba163db1ce4b11302f2bd2bd62f37f4437977ba5b"
  elsif Hardware::CPU.arm?
    url "#{base}/remote-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "ce56ea97617fe6f84172a9b6eb63fd53c4aed4514397b48b4105d80458fb3d63"
  else
    url "#{base}/remote-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "ef260b0f3f83eb698ea38f7ed2a9a7d633f22bbb2be49bad9ce529eea5256a4a"
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
