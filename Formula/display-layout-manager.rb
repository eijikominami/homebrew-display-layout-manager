class DisplayLayoutManager < Formula
  include Language::Python::Virtualenv

  desc "macOS用ディスプレイレイアウト自動設定ツール"
  homepage "https://github.com/eijikominami/display-layout-manager"
  url "https://github.com/eijikominami/display-layout-manager/archive/v1.1.4.tar.gz"
  sha256 "bf43479528aec90334ec03a38fd9881256f592a0b1626646051cd6d7dd1ec358"
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
    
    # セットアップ完了メッセージ
    puts <<~EOS
      Display Layout Manager がインストールされました。
      
      基本的な使用方法:
        display-layout-manager --save-current     # 現在のレイアウトを保存
        display-layout-manager                    # 保存されたレイアウトを適用
        display-layout-manager --show-displays   # 接続されたディスプレイを表示
      
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
