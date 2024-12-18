class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https://github.com/stephenberry/glaze"
  url "https://github.com/stephenberry/glaze/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "e9e267782f350ce507e27bafd7db696dc1405d0571f2613ae90299354584b0c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824e409636a66e392e1ea2f0c74407cf7c858c98d9694f98e9d3e2f6e41ac77e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824e409636a66e392e1ea2f0c74407cf7c858c98d9694f98e9d3e2f6e41ac77e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "824e409636a66e392e1ea2f0c74407cf7c858c98d9694f98e9d3e2f6e41ac77e"
    sha256 cellar: :any_skip_relocation, sonoma:        "824e409636a66e392e1ea2f0c74407cf7c858c98d9694f98e9d3e2f6e41ac77e"
    sha256 cellar: :any_skip_relocation, ventura:       "824e409636a66e392e1ea2f0c74407cf7c858c98d9694f98e9d3e2f6e41ac77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a01a3c7c004318744d3089c916dba9887d83224a661f622a0eafe1c13df2b41"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :test

  def install
    args = %w[
      -Dglaze_DEVELOPER_MODE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    # Issue ref: https://github.com/stephenberry/glaze/issues/1500
    ENV.append_to_cflags "-stdlib=libc++" if OS.linux?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <glaze/glaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}/glaze"
    system "cmake", "--build", "build"
    system "./build/glaze_test"
  end
end
