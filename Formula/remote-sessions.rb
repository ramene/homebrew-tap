class RemoteSessions < Formula
  desc "Drive and record Claude Code Remote Control sessions"
  homepage "https://github.com/ramene/remote-sessions"
  license "MIT"

  release = "0.2.3"
  base = "https://github.com/ramene/remote-sessions/releases/download/remote-sessions-v#{release}"

  if OS.mac?
    url "#{base}/remote-sessions-#{release}-macos-universal.tar.gz"
    sha256 "955872c7af70d7a8970871f9ff7bb918f118e8a241f6f91062086913489fa365"
  elsif Hardware::CPU.arm?
    url "#{base}/remote-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "d5c770934ed3246071bf0e4dbf974437e8eeb61eca5407c2d7cac50deff200f9"
  else
    url "#{base}/remote-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "4e4efac9ef9ad1913e118dfed432307e331bc69a0007d4059c422c84830444e9"
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
