class Tam < Formula
  desc "A tasks manager cli tool"
  homepage "https://github.com/wst7/tam"
  version "1.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wst7/tam/releases/download/v1.0.14/tam-aarch64-apple-darwin.tar.gz"
      sha256 "da3d85f06607c106748522e1c3b20d59f785eab85f123e146c1dd3b147e48729"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wst7/tam/releases/download/v1.0.14/tam-x86_64-apple-darwin.tar.gz"
      sha256 "de50919497c22e12af0ce72bfa16a2dfaec1ec34046fc57352dd626aee131107"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wst7/tam/releases/download/v1.0.14/tam-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9630023a52ae277d7362a8d6ecc66b1e44f008fe5818eb1f7aadb71731ddf16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wst7/tam/releases/download/v1.0.14/tam-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aa43ed7d49329e791a51486b74e446798dc4e6d889449f792c3bcb0454f10a4c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tam"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tam"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tam"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tam"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
