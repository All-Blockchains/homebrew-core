class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.7.0.tar.xz"
  sha256 "240849b7330308e095d99d71b5b3c6b2b2448e362c3cb5a664a43fffc650ec0a"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "12c0f1fce18439ea4801596a1d7b748b5fe410af892e92521656ec61b9d97be9"
    sha256 arm64_sonoma:  "5c60c7caeb51d40b93e032f8328ed26525f3c143db0fd3a167989cfe4590779b"
    sha256 arm64_ventura: "4ab4474a5759f6c9fa01a9d2d54f8612cd9ed3f99108a7f64f0612a8cff217d3"
    sha256 sonoma:        "75b3f14e173de182d558db82bf5a1fe29ce7d4af9cffe51d3ebb71b294210584"
    sha256 ventura:       "77d7351f9e3fc34254d61f883615d986cf49dc0c4ab51697ead553a71d7b4da7"
    sha256 x86_64_linux:  "b79ef450089c3402c49e556c9c68309f719d0b5a532b179225e43c1c8d06373d"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}/cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib} -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
