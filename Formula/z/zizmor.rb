class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3eed2efbe34abdf8d23c074d611cbae82d1392d0a3f58303467a6ca6a64f722a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1ea021aef7d1ca2a5d1c6168bb5b5e17c75a40b5e26845090ff6ee482c48ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83083e3744d9b133f887d3dc70d569c738ad64421dc7f5a7d80236f7d5cab64c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830eb74dd692ddaffd7f0eea36a3adb12fb0f807f4335e8f0f6de84830315285"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f8f50f9687f15efcef6a4f4cfef4dee9ba131e0e773e83aa51258573ba87ae"
    sha256 cellar: :any_skip_relocation, ventura:       "06666fdfa12f05041750abdb23bdf1f37018ea41697f0105355f5d5d6669768c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfdd2784cf53a72b1af9a758fd310608ce8cd40299c4888acdb0ad876ed15e61"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
