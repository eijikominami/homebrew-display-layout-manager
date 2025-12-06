class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.3.1.tar.gz"
  sha256 "4a39a681a107160aa5ce40f5db93e472dc629f03c604c7ad9facbb794d50b850"
  license "MIT"

  depends_on "python@3.11"
  depends_on "jakehilborn/jakehilborn/displayplacer"
  depends_on "grep"

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/b2/e2/2e6a47951290bd1a2831dcc50aec4b25d104c0cf00e8b7868cbd29cf3bfe/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

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
    
    # セットアップ完了メッセージ
    puts <<~EOS
      Display Layout Manager がインストールされました。
      
      CLI使用方法:
        display-layout-manager --save-current     # 現在のレイアウトを保存
        display-layout-manager                    # 保存されたレイアウトを適用
        display-layout-manager --show-displays   # 接続されたディスプレイを表示
      
      メニューバーアプリ:
        display-layout-manager-menubar            # メニューバーアプリを起動
        display-layout-manager-menubar --enable-auto-launch  # 自動起動を有効化
      
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
