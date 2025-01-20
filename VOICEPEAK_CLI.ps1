Param(
  [string]$text,
  [switch]$narratorlist,
  [string]$narrator,
  [string]$emotionlist,
  [string]$emotion,
  [switch]$save,
  [string]$outpath,
  [switch]$overwrite,
  [switch]$help
)

$voicepeak_path = "C:\Program Files\VOICEPEAK\voicepeak.exe"

if ($help -eq $true) {
  Start-Process -Filepath Powershell.exe -ArgumentList '-command &{echo "VOICEPEAK_CLI.ps1` [[-text]` `<String`>]` `[[-narratorlist]` `<String`>]` `[[-narrator]` `<String`>]` `[[-emotionlist]` `<String`>]` `[[-emotion]` `<String`>]` `[[-save]]` `[[-outpath]` `<String`>]` `[-overwrite]`n -text 読み上げテキストの設定を設定します。 原則必須のパラメータです。パラメータ指定文字列`(-text`)は省略可能です。`n  -narratorlist ナレーター`(narrator`)のリストを取得します。 省略可能なパラメータです。このオプションが有効な場合はtextパラメータの処理が行われません。`n -narrator ナレーターを設定します。 たぶん省略可能なパラメータです。省略した場合はVOICEPEAKのデフォルトボイスを利用するはずです。`n -emotionlist narratorの設定可能な感情値のリストを表示します。省略可能なパラメータです。このオプションが有効な場合はtextパラメータの処理が行われません。`n -emotion 感情値の設定をします。省略可能なパラメータです。`n -save 生成した音声ファイルを保存します。 省略可能なパラメータです。省略した場合は生成した音声ファイルを保存しません。`n -outpath 生成した音声ファイルの出力先パスを設定します。 省略可能なパラメータです。省略した場合はテンポラリフォルダに保存されます。 省略した場合のファイル名はtextパラメータで指定した文字列になります。 outpathのパラメータがディレクトリだった場合もファイル名はtextパラメータで指定した文字列になります。`n -overwrite outpathと同名のファイルが既に存在している場合に上書きします。 省略可能なパラメータです。省略した場合は上書き確認のダイアログが出ます。`n "; pause}'  
  exit 0
}

if ($narratorlist -eq $true) {
  Start-Process -Filepath $voicepeak_path '--list-narrator'
  exit 0
}

if ([string]::IsNullOrEmpty($text)) {
  $emotionlist = '--list-emotion ' + '"' + $emotionlist + '"'
  Start-Process -Filepath $voicepeak_path $emotionlist
  exit 0
}

if ([string]::IsNullOrEmpty($text)) {
  echo "次のパラメーターに値を指定してください:"
  $text = Read-Host "text"
}

$text = $text -replace "\s", "_"

$query = ' -s ' + '"' + $text + '"'

if ([string]::IsNullOrEmpty($narrator)) {
} else {
  $query = $query + ' -n ' + $narrator
}

if ([string]::IsNullOrEmpty($emotion)) {
} else {
  $query = $query + ' -e ' + $emotion
}

if ($save -eq $true) {
  if ([string]::IsNullOrEmpty($outpath)) {
    $outpath = [System.IO.Path]::GetTempPath() + $text + (Get-Date -Format "_yyyymmdd_HHmmss") + ".wav"
  } 
  if ((Test-Path $outpath) -eq "True") {
    if ((Test-Path -PathType Leaf $outpath) -eq $true) {
      if ($overwrite -eq $false) {
        $title = "上書き確認"
        $msg = $outpath + "を上書きしますか？"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "上書きする"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "上書きしない"
        $opts = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
        $res = $host.ui.PromptForChoice($title, $msg, $opts, 1)
        switch ($res)
        {
            1 {$outpath = $outpath+"_"+(Get-Date -Format "yyyymmdd_HHmmss")+".wav"}
          }
      }
    } else {
      $outpath = $outpath + "\" + $text + ".wav"
    }
  } else {
    New-Item -Path $outpath -Type File -Force > $null
  }
} else {
  $outpath = [System.IO.Path]::GetTempPath() + $text + (Get-Date -Format "_yyyymmdd_HHmmss") + ".wav"
}

$query = $query + ' -o ' + $outpath

function synthesis() {
  try {
    $fnsy = Start-Process -Filepath $voicepeak_path $query -Wait
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
}

$synthe = synthesis

function speech() {
  try {
    Wait-Process -Name "VOICEPEAK_CLI" >${NULL} 2>&1
    $tts = New-Object System.Media.SoundPlayer($outpath)
    $tts.PlaySync()
    if ($save -eq $false) {
      Remove-Item $outpath
    }
  }
  catch {
    Write-Host $_.Exception.Message
    exit 1
  }
}
speech
