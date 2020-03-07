<p align="center">
    <a href="https://opensource.org/licenses/BSD-3-Clause"><img src="https://img.shields.io/badge/license-bsd-orange.svg" alt="Licenses"></a>
</p>

# TB3DS_Termux
GAWK and Bourne Shell Scripts for Converting PDF(Public notice that teacher's license has expired included in Japanese Government Gazette) to Text File. 

# Introduction
Copyright 2020 The TB3DS_Termux Project Authors, GinSanaduki.
All rights reserved.
TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.  
This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later,  
Tesseract(Optical character recognition engine) version 4.0 or later developed by Google, Original author Ray Smith, Hewlett-Packard,  
Poppler(free software utility library for rendering Portable Document Format (PDF) documents) developed by freedesktop.org,  
and Termux(Android terminal emulator and Linux environment app that works directly with no rooting or setup required)  developed by Fredrik Fornwall, Henrik Grimler,  glow(Neo-Oli), Leonid Plyushch and others.  
Works on Android(on Termux, UserLAnd, and other...) / Windows(WSL, Windows Subsystem for Linux) / UNIX(Unix-like, as *nix. Example Linux, AIX, HP-UX...) / Mac OS X.  

The following commands need to be installed.
* gawk
* curl or wget
* poppler
* tesseract

# Termux上で稼働させたい方へ
* Termuxをまずはインストールしてください。  
Google Playストアから、「Termux」で検索すれば、出てきます。  
https://play.google.com/store/apps/details?id=com.termux&hl=ja  
本家  
https://termux.com/  

* 以下のコマンドを実行しておいてください。  
gawkは最初から入っているので、curl（と、ついでにwget）、poppler、tesseractを、Termuxに入っているパッケージからインストールします。  
一応、busyboxが入っているので、wgetは最初からあるにはあるのですが、それを指定するのもしんどいので・・・。  
```
# /homeにstorageディレクトリを作る
termux-setup-storage
# パッケージのアップデート
pkg update
# コマンドのインストール
pkg install curl
pkg install wget
pkg install poppler
pkg install tesseract
```

ダウンロードの配下にTB3DS_Termuxを配置した場合、以下のように実行してください。  
```
cd ~/storage/downloads/TB3DS_Termux
sh ShellScripts/01_CALL_UPDATE.sh
```

Androidの場合、CPUが4GBと他のPCに比べて小さい場合、6倍程度時間がかかると思ってください。  
まして、音楽とか聴きながらだと、他にCPUを使っているので、それだけ変換に時間がかかります。  
だいたい、8GBのWindowsのCPUで、3MBのPNGファイルをTesseractで変換するのに1分程度かかります。  
動作試験をしたのは、Lenovo Thinkpadと富士通 FMV LAPTOP-T50E9V47です。  
手持ちのKYOCERA TORQUE G4(Android9, 物理CPU2つ, 4GB)で、3MBのPNGファイルを変換したら、5分40秒程度かかりました。  
暇な時に流しておくのが、いいんじゃあないかと思いますよ。  

# その他の解説
* Windows版  
http://github.com/GinSanaduki/TB3DS  

# TB3DSに対するバグレポートは随時受け付けますが、それ以外の苦情は基本的に受け付けませんのであしからず。

