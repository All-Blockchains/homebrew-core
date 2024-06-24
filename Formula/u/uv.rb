class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.2.15.tar.gz"
  sha256 "d189c25aa07bd879f3e1483af6ed4499a890e9dd5a1300a65f924df8df4bab3e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f62f703d66fd303871d23bbd603e2f56d2f518be9856996189d8404d8bfdf0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "748838c30af9ea3648bb3ab48200a0311ce188dff2dcd797a8ae83d1e381b0e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b91f590848ec7bbf455b4d7e80a61c1a5aca375666f27b5740568e629c0a1f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "35f8599c943b218fabadcd750f4d7566356a870588df4227acb58001e6c841dd"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4b1dc18c9110a621d115ebe221bb0405e60930bec6473f266766944b566ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "060f8aae7108b32d6bb3760857a3b63071560e950c6aaa93af90c3cd42cbda37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa7aa6e6667af7265b3f01a6a1d98bbea871ec9eb3f0bbe75ad9c42aceb5b84"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled
  end
end
