class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.1.0.tar.gz"
  sha256 "81d58d3b6db4a632e6b1b7f8b6ee933da90e3e60206e0e9e49074f0f2a6ce804"
  license "MIT"

  depends_on "python@3.11"
  depends_on "jakehilborn/jakehilborn/displayplacer"
  depends_on "grep"

  def install
    virtualenv_install_with_resources
  end

  def post_install
    config_dir = "#{Dir.home}/Library/Application Support/DisplayLayoutManager"
    system "mkdir", "-p", config_dir
    system "chmod", "700", config_dir

    log_dir = "#{Dir.home}/Library/Logs/DisplayLayoutManager"
    system "mkdir", "-p", log_dir
    system "chmod", "700", log_dir
  end

  test do
    assert_match "Display Layout Manager", shell_output("#{bin}/display-layout-manager --version")
    system "#{bin}/display-layout-manager", "--run-tests"
  end
end
