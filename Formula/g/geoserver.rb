class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.25.2/geoserver-2.25.2-bin.zip"
  sha256 "b485dad47102053809d57880a3f863a3601f6e2c87c88b1ec1f66efe4e75de21"
  license "GPL-2.0-or-later"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # first-party download page for stable versions, since this is reliable.
  livecheck do
    url "https://geoserver.org/release/stable/"
    regex(%r{/GeoServer/v?(\d+(?:\.\d+)+)/?}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd32b569b16fe4797665a12fa8ae3ef5b0e31fc4e3ea3f240b62b70bea0d59cc"
  end

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<~EOS
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats
    <<~EOS
      To start geoserver:
        geoserver path/to/data/dir
    EOS
  end

  test do
    assert_match "geoserver path", shell_output("#{bin}/geoserver")
  end
end
