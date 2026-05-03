class GitLfs < Formula
  desc "Git LFS — large file storage for git, reimplemented in Rust"
  homepage "https://gitlab.com/rustutils/git-lfs"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.5.0/git-lfs-aarch64-darwin.tar.zst"
      sha256 "55daaea3457c14e8f5ac8ac88bbb212bc6a88c39ff9ee3f9f80ab82fad86aa50"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.5.0/git-lfs-x86_64-darwin.tar.zst"
      sha256 "843f4268afe868d31cb3a257e83a3f9ab1cb086c538dde74eebdd15aa0b141b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.5.0/git-lfs-aarch64-linux.tar.zst"
      sha256 "46a0f1a9318c554f24b684825afb03b3741b47b2c81918d9066e0258ff31ddce"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.5.0/git-lfs-x86_64-linux.tar.zst"
      sha256 "550c20104f73b3c199ba13d7cd04192259828016f75db793ffc473ae54f840d4"
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
