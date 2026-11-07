class CloudSessions < Formula
  desc "Drive Claude Code cloud sessions: start, read, watch and send"
  homepage "https://github.com/ramene/cloud-sessions"
  license "MIT"

  release = "0.2.1"
  base = "https://github.com/ramene/cloud-sessions/releases/download/cloud-sessions-v#{release}"

  if OS.mac?
    url "#{base}/cloud-sessions-#{release}-macos-universal.tar.gz"
    sha256 "646b9689fb63ee93859c7c5aa61baa1ff329234a8cb6f0fc7dadbdd654e96c95"
  elsif Hardware::CPU.arm?
    url "#{base}/cloud-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "aede99dd11366f878bff75d3689d3a4c541d8c023367a1996d69c6ad180c7ec8"
  else
    url "#{base}/cloud-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "9bf2900ba4349c15d21c51786c75f96898b56333bc904fa3078d8e093eb73bab"
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
