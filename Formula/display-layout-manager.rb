class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.4.0.tar.gz"
  sha256 "a4c785b6444859408c00b97236cd780abcda50488c863f04489b610a1ec8ead6"
  license "MIT"

  depends_on "python@3.11"
  depends_on "jakehilborn/jakehilborn/displayplacer"
  depends_on "grep"

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/b2/e2/2e6a47951290bd1a2831dcc50aec4b25d104c0cf00e8b7868cbd29cf3bfe/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  def install
    virtualenv_install_with_resources

    # Manually create menubar entry point if it doesn't exist
    unless (bin/"display-layout-menubar").exist?
      (bin/"display-layout-menubar").write <<~EOS
        #!/bin/bash
        exec "#{libexec}/bin/python" -m display_layout_manager.menubar "$@"
      EOS
      chmod 0755, bin/"display-layout-menubar"
    end
  end

  def post_install
    config_dir = "#{Dir.home}/Library/Application Support/DisplayLayoutManager"
    system "mkdir", "-p", config_dir
    system "chmod", "700", config_dir

    log_dir = "#{Dir.home}/Library/Logs/DisplayLayoutManager"
    system "mkdir", "-p", log_dir
    system "chmod", "700", log_dir

    # セットアップ完了メッセージ
    puts <<~EOS
      Display Layout Manager がインストールされました。

      CLI使用方法:
        display-layout-manager --save-current     # 現在のレイアウトを保存
        display-layout-manager                    # 保存されたレイアウトを適用
        display-layout-manager --show-displays   # 接続されたディスプレイを表示

      メニューバーアプリ:
        display-layout-menubar            # メニューバーアプリを起動
        display-layout-menubar --enable-auto-launch  # 自動起動を有効化

      設定ファイル:
        ~/Library/Application Support/DisplayLayoutManager/config.json

      ログファイル:
        ~/Library/Logs/DisplayLayoutManager/
    EOS
  end

  test do
    assert_match "Display Layout Manager", shell_output("#{bin}/display-layout-manager --version")
    system "#{bin}/display-layout-manager", "--run-tests"
  end
end
