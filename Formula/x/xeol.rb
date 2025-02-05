class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "abc5bfbdbf2f325d3957ea3a9992f25af1bb0f5e85eb0b6666d0899080985ef5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e10685819794180c332478791c95bdd3cf530316988b0066f2e93bb7044e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14546bd6908a08395a2e47b9722a8b71dbb5573ffb36ed07c6688239920eb1e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ca37e39aa875054b79af7b5fce4e950df3367720c8beb976e2a63c914a92990"
    sha256 cellar: :any_skip_relocation, sonoma:        "c16d9c302d027e78722592c58fb83010609ff9bbff084032885b8090f568c2a2"
    sha256 cellar: :any_skip_relocation, ventura:       "a7771325fd5a20e2478d7e21271d70b565749171eef0c58d7bf4a30e33c7f63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c1eb3ae580c51f6c68917cd78e410ebedcfe7c62310f0bace9d92dd9ecbf7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
