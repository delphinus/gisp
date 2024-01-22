# NAME

gisp - Google IME SKK for Perl

# SYNOPIS

    # Run the server
    % gisp

    # Specify the host
    % gisp -h 127.0.0.1 -p 55100

# DESCRIPTION

gisp は SKK プロトコルを実装したサーバーです。読みをリクエストすると返り値として
変換結果を返します。内部では読みを
[Google CGI API for Japanese](https://www.google.co.jp/ime/cgiapi.html) に送信
し、その返り値をそのまま使っています。

オプションを何も指定しなかった場合、`127.0.0.1:55100` で待ち受けます。AquaSKK
などの設定でこのホストとポート番号を指定してください。

レポジトリーには Homebrew Formula を同梱していますので、次のようにしてシステムに
登録し、ログイン時に自動的に起動させることができます。

    % brew tap delphinus/gisp
    % brew install gisp
    % brew services start gisp

NOTE: Homebrew に関する機能は、現時点では macOS でのみ動作を確認しています。

# OPTIONS

- **--host** _host_, **-h** _host_

    サーバーが起動するホスト名です。

    Default: `"127.0.0.1"`

- **--port** _port_, **-p** _port_

    サーバーが起動するポート番号です。

    Default: `55100`

- **--cache** `/path/to/file`, **-c** `/path/to/file`

    Google CGI API for Japanese にリクエストした結果をキャッシュするファイルのパスで
    す。

    Default: `~/.cache/gisp.txt`

- **--help**, **-h**

    このヘルプを表示して終了します。

- **--verbose**, **-v**

    実行ログを標準出力に吐きます。エラーについてはこのオプションを指定しない場合も標
    準エラー出力に吐きます。

- **--version**

    バージョン文字列を吐いて終了します。

# COPYRIGHT & LICENSE

Copyright 2023 JINNOUCHI Yasushi <me@delphinus.dev>

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

# SEE ALSO

- [SKKServ - PySocialSKKServ Wiki - PySocialSKKServ - OSDN](https://ja.osdn.net/projects/pysocialskkserv/wiki/SKKServ)
