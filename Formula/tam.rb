class Tam < Formula
  desc "A tasks manager cli tool"
  homepage "https://github.com/wst7/tam"
  version "1.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wst7/tam/releases/download/v1.0.13/tam-aarch64-apple-darwin.tar.gz"
      sha256 "19c4671a7489ae9465a966f4e526a5fc14463723b6b881efe9eee0b704657930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wst7/tam/releases/download/v1.0.13/tam-x86_64-apple-darwin.tar.gz"
      sha256 "93b36f9c89b0dee95a9abdd982c5dabbab7b1e64f6bee6aef434337ff19be97d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wst7/tam/releases/download/v1.0.13/tam-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fbf0b2cf11b1a2a04c7a89d1589d0b1b8eeb256c606a75e45e2200a276e0f21f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wst7/tam/releases/download/v1.0.13/tam-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98e3e5ebb695198ad2460310da76d9a0492096e8d946aaf1dc2a3bc6f7738520"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tam" if OS.mac? && Hardware::CPU.arm?
    bin.install "tam" if OS.mac? && Hardware::CPU.intel?
    bin.install "tam" if OS.linux? && Hardware::CPU.arm?
    bin.install "tam" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
