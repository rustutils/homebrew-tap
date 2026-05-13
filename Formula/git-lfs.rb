class GitLfs < Formula
  desc "Large file storage for git, reimplemented in Rust"
  homepage "https://gitlab.com/rustutils/git-lfs"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.6.0/git-lfs-aarch64-darwin.tar.zst"
      sha256 "2641be2a6734eeda094ce253cdec8260c2fa004f690a94f4964c4c2c549bdd3b"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.6.0/git-lfs-x86_64-darwin.tar.zst"
      sha256 "d37b81ffde2b79310cc71424dbbb2154404aea041390edf0e2006ffc76a37c22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.6.0/git-lfs-aarch64-linux.tar.zst"
      sha256 "4087c042a4da0a05b5179029470f4e2865e2ef6fbec1463020ada85e3d33d35b"
    end
    on_intel do
      url "https://github.com/rustutils/git-lfs/releases/download/v0.6.0/git-lfs-x86_64-linux.tar.zst"
      sha256 "5a2b8544a485c5a8d15d2da7e8d4ef4bdf2d3f369b60406db16fcb67de6f36e4"
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
