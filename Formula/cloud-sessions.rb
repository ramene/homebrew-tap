class CloudSessions < Formula
  desc "Drive Claude Code cloud sessions: start, read, watch and send"
  homepage "https://github.com/ramene/cloud-sessions"
  license "MIT"

  release = "0.2.0"
  base = "https://github.com/ramene/cloud-sessions/releases/download/cloud-sessions-v#{release}"

  if OS.mac?
    url "#{base}/cloud-sessions-#{release}-macos-universal.tar.gz"
    sha256 "d19351954663d089f7443f93131bd09289321eb775e127bb8f458004d6b5898b"
  elsif Hardware::CPU.arm?
    url "#{base}/cloud-sessions-#{release}-linux-aarch64.tar.gz"
    sha256 "d09ae2fbc20e02a7f316ddc42be61bf154d15be0183d58d91a1e77045f795231"
  else
    url "#{base}/cloud-sessions-#{release}-linux-x86_64.tar.gz"
    sha256 "9d6d1bf6afb6c85118015071e6e46af29973a9e31281363e553aa28dd00e9cad"
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
