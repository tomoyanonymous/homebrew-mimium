# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "213ce63edc6d7df7057dc22eba0f9014abd91d5f", tag: "v0.2.0"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "BINTRAY_ROOT"
    cellar :any
    sha256 "6cbbd244b30eea9732c9b5567a9c5091d55cab8b1bb54cee0e40031ed3991edc" => :catalina
    sha256 "b5bcb37818bbecf62fbbb46c77feb15e89bc98d98e0962d45881290b9a0fd4f5" => :x86_64_linux
  end
  depends_on "alsa-lib" unless OS.mac?
  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "pkg-config" => :build
  depends_on "gcc@9" unless OS.mac?
  depends_on "libsndfile"
  depends_on "llvm@9"

  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    mkdir "build"
    cd "build"
    if OS.mac?
      if MacOS.version >= :mojave
        sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
        ENV["HOMEBREW_SDKROOT"] = sdk_path
      end
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..",
             "-DCMAKE_OSX_SYSROOT=#{sdk_path}"
    else
      ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib"
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    end
    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "true"
  end
end
