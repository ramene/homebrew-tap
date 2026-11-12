class RemoteSessions < Formula
  desc "Drive and record Claude Code Remote Control sessions"
  homepage "https://github.com/ramene/remote-sessions"
  license "MIT"

  release = "0.3.2"
  base = "https://github.com/ramene/remote-sessions/releases/download/remote-sessions-v#{release}"

  if OS.mac?
    url "#{base}/remote-sessions-#{release}-macos-universal.tar.gz"
    sha256 "9b87622e0d12f6d16c1e70e257db1c71ec903630a250d3e9a5858f87b249416f"
  elsif Hardware::CPU.arm?
    url "#{base}/remote-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "a2181a768178f06e2a374af0e387e30d1594ac4b52fe88c53b686a023adb9215"
  else
    url "#{base}/remote-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "13c587a372c0ff51ab086bf70e9d0d848300ccac765ea62d91a0f66dd3dee28d"
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
