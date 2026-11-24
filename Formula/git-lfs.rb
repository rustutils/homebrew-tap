class GitLfs < Formula
  desc "Large file storage for git, reimplemented in Rust"
  homepage "https://gitlab.com/rustutils/git-lfs"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.11.0/git-lfs-aarch64-darwin.tar.zst"
      sha256 "60e34274512f6d338d343f5fdc9364931a4394b57456b48d89521715b2e1f841"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.11.0/git-lfs-x86_64-darwin.tar.zst"
      sha256 "e0eb7f621a14cb6ec27cb4c1e7ec7c2a8bd11b88b2653da9f96fd7b286d10a1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.11.0/git-lfs-aarch64-linux.tar.zst"
      sha256 "cd5861610b95f8c31e45fb19f19bb0e8b47dcc34e60cfdc14a1697512cf8c02f"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.11.0/git-lfs-x86_64-linux.tar.zst"
      sha256 "c696ab71884aec65990b4302d9f3bd89ae2998ed65e99ee5af47dff285282482"
    end
  end

  conflicts_with "git-lfs", because: "both install a `git-lfs` binary"

  def install
    bin.install "bin/git-lfs"
    man1.install Dir["share/man/man1/*.1"]
    doc.install Dir["share/doc/git-lfs/*"]
  end

  test do
    system bin/"git-lfs", "--version"
  end
end
