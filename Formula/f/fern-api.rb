class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.28.tgz"
  sha256 "2ca9fffea0a607fb1509f160be56edacce6f043626feae653e5dc38c3a46a86a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cb148790383e9f075cc3eb33373c5c26b77d64b4ffcd392ae025720ec19003d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
