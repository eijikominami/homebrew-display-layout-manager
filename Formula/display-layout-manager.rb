class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.1.2.tar.gz"
  sha256 "dc6ad1eba04d843357f757fea268e893d1b9bfaf2837e6d353bc09daa9889290"
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

    # 常駐機能の自動セットアップ
    system "#{bin}/display-layout-manager", "--enable-daemon"
    
    # セットアップ完了メッセージ
    puts <<~EOS
      Display Layout Manager がインストールされました。
      
      常駐監視機能が自動的に有効化されています。
      ディスプレイ設定の変更時に自動的にレイアウトが適用されます。
      
      管理コマンド:
        display-layout-manager --status-daemon    # 状態確認
        display-layout-manager --disable-daemon   # 無効化
        display-layout-manager --enable-daemon    # 有効化
      
      設定ファイル:
        ~/Library/Application Support/DisplayLayoutManager/config.json
        ~/Library/Application Support/DisplayLayoutManager/daemon.json
      
      ログファイル:
        ~/Library/Logs/DisplayLayoutManager/
    EOS
  end

  def uninstall_preflight
    # 常駐機能を停止・削除
    system "#{bin}/display-layout-manager", "--disable-daemon"
  end

  test do
    assert_match "Display Layout Manager", shell_output("#{bin}/display-layout-manager --version")
    system "#{bin}/display-layout-manager", "--run-tests"
  end
end
