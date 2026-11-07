class CloudSessions < Formula
  desc "Drive Claude Code cloud sessions: start, read, watch and send"
  homepage "https://github.com/ramene/cloud-sessions"
  license "MIT"

  release = "0.1.1"
  base = "https://github.com/ramene/cloud-sessions/releases/download/cloud-sessions-v#{release}"

  if OS.mac?
    url "#{base}/cloud-sessions-#{release}-macos-universal.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000001"
  elsif Hardware::CPU.arm?
    url "#{base}/cloud-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000002"
  else
    url "#{base}/cloud-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "0000000000000000000000000000000000000000000000000000000000000003"
  end

  def install
    bin.install "cloud-sessions"
    pkgshare.install "plugin"
  end

  def caveats
    <<~EOS
      Add the Claude Code plugin (the marketplace is in the repository):
        claude plugin marketplace add ramene/cloud-sessions
        claude plugin install cloud-sessions@cloud-sessions
      Or load the copy that came with this formula:
        claude --plugin-dir #{opt_pkgshare}/plugin
      Allow repositories yourself: export CLOUD_SESSIONS_REPOS=owner/name
      Inside Claude Code, reading uses its built-in RemoteTrigger tool: nothing to set up. To read from a terminal,
      opt in yourself: cloud-sessions auth use-claude-login (a claude setup-token token cannot read sessions).
    EOS
  end

  test do
    assert_match "usage: cloud-sessions", shell_output("#{bin}/cloud-sessions help")
    assert_match '"ok":false', shell_output("#{bin}/cloud-sessions send 'bad id' --message hi 2>&1", 1)
  end
end
