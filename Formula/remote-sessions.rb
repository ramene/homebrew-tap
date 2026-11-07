class RemoteSessions < Formula
  desc "Drive and record Claude Code Remote Control sessions"
  homepage "https://github.com/ramene/remote-sessions"
  license "MIT"

  release = "0.2.2"
  base = "https://github.com/ramene/remote-sessions/releases/download/remote-sessions-v#{release}"

  if OS.mac?
    url "#{base}/remote-sessions-#{release}-macos-universal.tar.gz"
    sha256 "fcfe46814363b3863521387c1ab0397e0e9c0671b287143a7cfd610998e882da"
  elsif Hardware::CPU.arm?
    url "#{base}/remote-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "b010e50ad207bf75e738114512b48e31edf81fb8c2d9785145ceee9e57094f14"
  else
    url "#{base}/remote-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "09abb5aab6e2b53e804c3af1c99022022891f0465a55cca2bea1754fd7d7e857"
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
