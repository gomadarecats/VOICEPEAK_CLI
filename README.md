# VOICEPEAK_CLI
概要

    WindowsのCLI(PowerShell)からVOICEPEAKでテキストを読み上げるスクリプトです。

構文

    VOICEPEAK_CLI.ps1 [[-text] <String>] [[-narratorlist] <String>] [[-narrator] <String>] [[-emotionlist] <String>] [[-emotion] <String>] [[-save]] [[-outpath] <String>] [-overwrite]

説明

    A.I.VOICE Editor API を利用してText, VoicePresetNames, CurrentVoicePresetName を取得・設定します。
    Text: テキスト形式の入力テキストを取得または設定します。
    VoicePresetNames: 登録されているボイスプリセット名を取得します。
    CurrentVoicePresetName: 現在のボイスプリセット名を取得または設定します。
    スクリプト内の$PathをAI.Talk.Editor.Api.dllの適切なパスに指定してください。


パラメーター

    -text
    読み上げテキストの設定を設定します。
    原則必須のパラメータです。パラメータ指定文字列(-text)は省略可能です。

    -narratorlist
    ナレーター(narrator)のリストを取得します。
    省略可能なパラメータです。このオプションが有効な場合はtextパラメータの処理が行われません。

    -narrator
    ナレーターを設定します。
    たぶん省略可能なパラメータです。省略した場合はVOICEPEAKのデフォルトボイスを利用するはずです。

    -emotionlist
    narratorの設定可能な感情値のリストを表示します。省略可能なパラメータです。このオプションが有効な場合はtextパラメータの処理が行われません。

    -emotion
    感情値の設定をします。省略可能なパラメータです。

    -save
    生成した音声ファイルを保存します。
    省略可能なパラメータです。省略した場合は生成した音声ファイルを保存しません。

    -outpath
    生成した音声ファイルの出力先パスを設定します。
    省略可能なパラメータです。省略した場合はテンポラリフォルダに保存されます。
    省略した場合のファイル名はtextパラメータで指定した文字列になります。
    outpathのパラメータがディレクトリだった場合もファイル名はtextパラメータで指定した文字列になります。

    -overwrite
    outpathと同名のファイルが既に存在している場合に上書きします。
    省略可能なパラメータです。省略した場合は上書き確認のダイアログが出ます。
### Usage
```
<path>\VOICEPEAK_CLI.ps1 exampletext
    規定のナレーターで"exampletext"を読み上げます。

<path>\VOICEPEAK_CLI.ps1 -narratorlist
    ナレーターの一覧を出力します。

<path>\VOICEPEAK_CLI.ps1 -emotionlist <narrotorName>
    ナレーターの感情値一覧を出力します。

<path>\VOICEPEAK_CLI.ps1 -text exampletext -narrator <narrotorName>
    指定したナレーターで"exampletext"を読み上げます。

<path>\VOICEPEAK_CLI.ps1 -text exampletext -save -outpath C:\output.wav -overwrite
    規定のナレーターで"exampletext"を読み上げます。
    生成した音声ファイルをC:\output.wavに保存します。
    C:\output.wavが既に存在している場合は上書きします。

```

- $voicepeak_path に <VOICEPEAKインストールディレクトリ>\voicepeak.exe を入れてください
  - おそらくデフォルトであろう `C:\Program Files\VOICEPEAK\voicepeak.exe` を入れています

ps2exeでps1をexeにしたもをリリースしていますが、VOICEPEAKのインストールディレクトリが\
`C:\Program Files\VOICEPEAK\voicepeak.exe` 以外だと動きません

アイコンはBing Image Creatorさんに生成いただきました
