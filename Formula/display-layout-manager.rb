class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.3.0.tar.gz"
  sha256 "4c5fe5661a3cda33ade7fc96bc4bb230c3be45bd2c6db105503c3610b574df40"
  license "MIT"

  depends_on "python@3.11"
  depends_on "jakehilborn/jakehilborn/displayplacer"
  depends_on "grep"

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/3d/11/5696c4f1f5d0e8b9a3e7f8e0e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3/rumps-0.4.0.tar.gz"
    sha256 "95b5e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/pyobjc-framework-Cocoa/pyobjc_framework_Cocoa-9.2.tar.gz"
    sha256 "..."
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
