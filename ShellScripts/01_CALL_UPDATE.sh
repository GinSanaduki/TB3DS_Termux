#!/bin/sh
# 01_CALL_UPDATE.sh
# sh ShellScripts/01_CALL_UPDATE.sh

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2020 The TB3DS_Termux Project Authors, GinSanaduki.
# All rights reserved.
# TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later,
# Tesseract(Optical character recognition engine) version 4.0 or later developed by Google, Original author Ray Smith, Hewlett-Packard,
# Poppler(free software utility library for rendering Portable Document Format (PDF) documents) developed by freedesktop.org,
# and Termux(Android terminal emulator and Linux environment app that works directly with no rooting or setup required) 
# developed by Fredrik Fornwall, Henrik Grimler,  glow(Neo-Oli), Leonid Plyushch and others.

# ------------------------------------------------------------------------------------------------------------------------

# GAWKのインストール有無
which gawk > /dev/null 2>&1
GAWKExistRet=$?
test $GAWKExistRet -ne 0 && echo "No GAWK command found. TB3DS needs GAWK." && exit 99

# curlまたはwgetのインストール有無
which curl > /dev/null 2>&1
CURLExistRet=$?
which wget > /dev/null 2>&1
WGETExistRet=$?
test $CURLExistRet -ne 0 -a $WGETExistRet -ne 0 && echo "No HTTP-GET/POST command found. TB3DS needs curl or wget." && exit 99

# 両方インストールしていた場合、curlを使用する
HTTP_Command="CURL"
test $CURLExistRet -ne 0 && HTTP_Command="WGET"

# Tesseractのインストール有無
which tesseract > /dev/null 2>&1
TESSERACTExistRet=$?
test $TESSERACTExistRet -ne 0 && echo "No Tesseract-OCR command found. TB3DS needs Tesseract." && exit 99

# Popplerのインストール有無
which pdftoppm > /dev/null 2>&1
POPPLERExistRet=$?
test $POPPLERExistRet -ne 0 && echo "No Poppler command found. TB3DS needs Poppler(pdftoppm)." && exit 99

DATE=`date +%Y%m%d`
EDITFILE_ORIGIN="AcquiredHTML/List_of_disciplinary_dismissal_disposal_"$DATE".txt"
EXTRACTLIST="EditedHTML/ExtractList_"$DATE".tsv"
EXEC_SHELL="EditedHTML/ExecShell.sh"
DEUXLIST="EditedHTML/DeuxList.txt"
HTML_HASH="HashConf/HTMLHashList_"$DATE".tsv"
PDF_HASH="HashConf/PDFHashList_"$DATE".tsv"
PNG_HASH="HashConf/PDFHashList_"$DATE".tsv"
TXT_HASH="HashConf/TXTHashList_"$DATE".tsv"
COMPRESSION_DIR="GeneratedFile_"$DATE
COMPRESSION_FILE="StoreCompressionFile/"$COMPRESSION_DIR".tar.gz"

EDITDIR_TROIS="EditedHTML_Trois"
TROISLIST="EditedHTML/TroisList_"$DATE".txt"
TARGETLINK="EditedHTML/TargetLink_"$DATE".tsv"
TARGETLINK_DEUX="EditedHTML/TargetLink_Deux_"$DATE".tsv"
TARGETLINK_TROIS="EditedHTML/TargetLink_Trois_"$DATE".tsv"
PDFFILELIST="EditedHTML/PDFFileList_"$DATE".txt"
PNGFILELIST="EditedHTML/PNGFileList_"$DATE".txt"
TXTFILELIST="EditedHTML/TXTFileList_"$DATE".txt"
EDITTXTFILELIST="EditedHTML/EditTXTFileList_"$DATE".txt"
EXECENVLIST="ExecuteEnvironment.txt"
EXECCPULIST="ExecuteCPU.txt"


# 並列処理数を確定させる。
# 原則は、物理コア数+1とする。
gawk -f AWKScripts/01_UPDATE/03_SubSystem/06_SubSystem_06.awk
Parallel=$?

gawk -f AWKScripts/01_UPDATE/01_Controller/01_Sonate_fur_Klavier_Nr29_Hammerklavier_B_Dur_Op106.awk -v HTTP_Command=$HTTP_Command
RetCode=$?
test $RetCode -ne 0 && exit 99;

# -------------------------------------------------------------------------------------------------------------------------------

sed -e 's/\r//g' $EDITFILE_ORIGIN | 
gawk '/<div id="todayBox" class="todayBox">/,/<\/div><!-- \/toggleBox -->/{gsub("\t","");print;}' | \
fgrep -e '<dt>' -e '<li>' | \
sed -e 's/<\/dt>//g' | \
sed -e 's/<\/a>//g' | \
sed -e 's/<\/li>//g' | \
sed -e 's/<br>//g' | \
sed -e 's/">/\t/g' | \
sed -e 's/<li><a href=".//g' | \
gawk '{gsub(" ","");print;}' | \
gawk 'BEGIN{Wareki = "";} /^<dt>/{Wareki = $0; gsub("<dt>","",Wareki);next;}{print Wareki"\t"$0;}' | \
gawk 'BEGIN{FS = "\t"; URL = "https://kanpou.npb.go.jp";}{print $1"\t"URL$2"\t"$3}' > $EXTRACTLIST

: > $EXEC_SHELL
: > $DEUXLIST
gawk 'BEGIN{FS = "\t";}{sub("https://kanpou.npb.go.jp/","EditedHTML_Deux/",$2); print $2;}' $EXTRACTLIST > $DEUXLIST

# 当日日付のHTMLから取得したハイパーリンクのリストに対応したHTMLを格納するディレクトリを無条件に生成
gawk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > /dev/null 2>&1";}' $DEUXLIST > $EXEC_SHELL
xargs -P $Parallel -a $EXEC_SHELL -r -I{} sh -c '{}'

# 当該HTMLファイルが存在しない、または空ファイルである場合、取得し10秒のインターバルを空ける
: > $EXEC_SHELL
gawk -f AWKScripts/01_UPDATE/03_SubSystem/01_SubSystem_01.awk -v HTTP_Command=$HTTP_Command $DEUXLIST > $EXEC_SHELL
RetCode=$?
test $RetCode -ne 0 && exit 99;
sh $EXEC_SHELL

: > $EXEC_SHELL
: > $HTML_HASH
# DEUXLISTのファイルに対するハッシュ値を取得
gawk 'BEGIN{print "#!/bin/sh"; print "echo Starting generate a hash value using the contents of HTML files... 1>&2";}{print "sha512sum "$0;}END{print "echo Generate a hash value Completed. 1>&2";}' $DEUXLIST > $EXEC_SHELL
sh $EXEC_SHELL | gawk '{print $2"\t"$1;}' > $HTML_HASH

# DEUXLISTのファイルをEditedHTML_Trois直下にコピー
: > $EXEC_SHELL
rm -rf $EDITDIR_TROIS > /dev/null 2>&1
mkdir $EDITDIR_TROIS > /dev/null 2>&1
gawk 'BEGIN{FS = "\t";}{print $1;}' $HTML_HASH | \
gawk 'BEGIN{FS = "/";}{print "cat "$0" | sed -e \047s/\r//g\047 > EditedHTML_Trois/"$4;}' > $EXEC_SHELL
echo "Starting HTML Copy..."
xargs -P $Parallel -a $EXEC_SHELL -r -I{} sh -c '{}'
echo "HTML Copy Completed."

# 「教育職員免許状取上げ処分」、「教育職員免許状失効」で抽出
fgrep '<span class="text">' $EDITDIR_TROIS/*.html | \
fgrep -A 1 -e "教育職員免許状取上げ処分" -e "教育職員免許状失効" | \
sed -e 's/-/:/g' | \
tr -d '\t' | \
sed -e 's/:/\t/g' | \
gawk '{if(NR % 3){ORS="\t"} else {ORS="\n"};print;}' | \
gawk 'BEGIN{FS = "\t";}{print $1"\t"$2"\t"$3"\t"$4;}' | \
sed -e 's/"//g' | \
sed -e 's/<span class=text>//g' | \
sed -e 's/<\/span>//g' | \
gawk -f AWKScripts/01_UPDATE/03_SubSystem/05_SubSystem_05.awk | \
gawk 'BEGIN{FS = "\t";}{print $1"\t"$2"\t"$4"\t"$5;}' > $TARGETLINK

gawk 'BEGIN{FS = "\t";}{print "fgrep -B 1 \047"$2"\047 "$1;}' $TARGETLINK | \
sh | \
gawk '{if(NR % 2 == 1){print;}}' | \
tr -d '\t' | \
sed -e 's/"//g' | \
sed -e 's/<a href=//g' | \
sed -e 's/>//g' > $TARGETLINK_DEUX
paste -d '\t' $TARGETLINK $TARGETLINK_DEUX > $TARGETLINK_TROIS

# 例として、https://kanpou.npb.go.jp/20191211/20191211h00150/20191211h001500031f.html
# の場合、20191211が発行日時で、h00150が本紙150号、00031fが31ページ、という意味。
# PDFプラグインのソースは、https://kanpou.npb.go.jp/20191211/20191211h00150/pdf/20191211h001500031.pdf
# 存在しない場合、または空ファイルの場合、AcquiredPDFに向けてダウンロードし10秒のインターバルを空ける
: > $PDFFILELIST
gawk 'BEGIN{FS = "\t";}{Tex = $5; Tex2 = $5; sub("f.html","",Tex); sub("f.html",".pdf",Tex2); print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"Tex"\t"Tex2;}' $TARGETLINK_TROIS | \
gawk -f AWKScripts/01_UPDATE/03_SubSystem/02_SubSystem_02.awk -v HTTP_Command=$HTTP_Command | \
sh

: > $EXEC_SHELL
: > $PDF_HASH
# PDFFILELISTのファイルに対するハッシュ値を取得
gawk 'BEGIN{print "#!/bin/sh"; print "echo Starting generate a hash value using the contents of PDF files... 1>&2";}{print "sha512sum "$0;}END{print "echo Generate a hash value Completed. 1>&2";}' $PDFFILELIST > $EXEC_SHELL
sh $EXEC_SHELL | gawk '{print $2"\t"$1;}' > $PDF_HASH

# pdftoppmのコマンド生成
mkdir PNGHash > /dev/null 2>&1
mkdir ConvertedPNG > /dev/null 2>&1
rm -rf TempShell > /dev/null 2>&1
mkdir TempShell > /dev/null 2>&1
rm -r TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1
: > $PNG_HASH
gawk -f AWKScripts/01_UPDATE/03_SubSystem/03_SubSystem_03.awk $PDFFILELIST
echo "Converting PDF to PNG process..."
: > $EXEC_SHELL
ls -1 TempShell/*.sh | \
gawk '{print "sh "$0;}' > $EXEC_SHELL
xargs -P $Parallel -a $EXEC_SHELL -r -I{} sh -c '{}'
rm -rf TempShell > /dev/null 2>&1
fgrep -q '1' TempRetCode/RetCode_*.txt
RetCode=$?
rm -rf TempRetCode > /dev/null 2>&1
test $RetCode -eq 0 && echo "後続処理を実行せずに終了します。" && exit 99
echo "Convert PDF to PNG process Completed."

# tesseractのコマンド生成
mkdir TXTHash > /dev/null 2>&1
mkdir ConvertedTXT > /dev/null 2>&1
rm -rf TempShell > /dev/null 2>&1
mkdir TempShell > /dev/null 2>&1
rm -r TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1
rm -r RelayBit > /dev/null 2>&1
mkdir RelayBit > /dev/null 2>&1

PDFFILELIST_Line=`gawk -f AWKScripts/01_UPDATE/03_SubSystem/16_SubSystem_16.awk $PDFFILELIST`

: > $TXT_HASH
gawk -f AWKScripts/01_UPDATE/03_SubSystem/04_SubSystem_04.awk -v PDFFILELIST_Line=$PDFFILELIST_Line $PDFFILELIST
RetCode=$?
test $RetCode -ne 0 && echo "後続処理を実行せずに終了します。" && exit 99
echo "Starting OCR process...";
echo "Converting PNG to TXT...";
: > $EXEC_SHELL
ls -1 TempShell/*.sh | \
gawk '{print "sh "$0" & ";} END{print "wait"; print "exit 0";}' > $EXEC_SHELL

# Tessetactの場合、物理コアをすべて使えるだけ使用するようなので、並列にしたらするだけ遅くなる。
# 2並列ならまだ直列実行と同レベルなのでマシだが、3並列になると直列実行より遅い。
# そういうことは、先に書いといてくれ・・・。
sh $EXEC_SHELL
rm -rf TempShell > /dev/null 2>&1
fgrep -q '1' TempRetCode/RetCode_*.txt
RetCode=$?
rm -rf TempRetCode > /dev/null 2>&1
rm -rf RelayBit > /dev/null 2>&1
test $RetCode -eq 0 && echo "後続処理を実行せずに終了します。" && exit 99
echo "OCR process Completed."

echo "Remove Terminal Row Process Starting..."

# 終端に文字化けが必ず発生するので、最終行を削除
# Tesseractは、どのプラットフォームもこんなものなのか？
# ターミナルで流す分には気づかないが、Sakura Editorで開くと気づく・・・。
: > $EXEC_SHELL
rm -rf TempEditedTXT > /dev/null 2>&1
mkdir TempEditedTXT > /dev/null 2>&1
rm -rf TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1

gawk -f AWKScripts/01_UPDATE/03_SubSystem/08_SubSystem_08.awk $TXTFILELIST > $EXEC_SHELL
sh $EXEC_SHELL
fgrep -q -v '0' TempRetCode/RetCode_*.txt
RetCode=$?
rm -rf TempRetCode > /dev/null 2>&1
test $RetCode -eq 0 && echo "Remove Terminal Row Process Failed." && echo "後続処理を実行せずに終了します。" && exit 99
echo "Remove Terminal Row Process Completed."

# 「教育職員免許状」から$TARGETLINK_TROISの4カラム目の「関係」を除外したものまでを抽出
echo "Object Domain Extraction Process Starting..."
: > $EXEC_SHELL
mkdir EditedTXT > /dev/null 2>&1
rm -rf TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1
# 教育職員免許状の場合、「落音職員免許状」となる場合があったので、
# 教育職員免許法(昭和24年法律第147号)で検知する。
gawk -f AWKScripts/01_UPDATE/03_SubSystem/09_SubSystem_09.awk $TARGETLINK_TROIS > $EXEC_SHELL
sh $EXEC_SHELL
fgrep -q -v '0' TempRetCode/RetCode_*.txt
RetCode=$?
rm -rf TempRetCode > /dev/null 2>&1
test $RetCode -eq 0 && echo "Object Domain Extraction Process Failed." && echo "後続処理を実行せずに終了します。" && exit 99
rm -rf TempEditedTXT > /dev/null 2>&1

# EDITTXTFILELISTのファイルが空ファイルではないことを確認する
rm -rf TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1
: > $EXEC_SHELL
gawk -f AWKScripts/01_UPDATE/03_SubSystem/10_SubSystem_10.awk $EDITTXTFILELIST > $EXEC_SHELL
sh $EXEC_SHELL

fgrep -q 'IS EMPTY FILE.' TempRetCode/RetCode_*.txt
RetCode=$?
test $RetCode -eq 0 && fgrep -h 'IS EMPTY FILE.' TempRetCode/RetCode_*.txt | cat && echo "後続処理を実行せずに終了します。" && exit 99
rm -rf TempRetCode > /dev/null 2>&1
echo "Object Domain Extraction Process Completed."

# 生成ファイルを圧縮
rm -rf TempRetCode > /dev/null 2>&1
mkdir TempRetCode > /dev/null 2>&1
rm -rf $COMPRESSION_DIR > /dev/null 2>&1
mkdir $COMPRESSION_DIR > /dev/null 2>&1
mkdir $COMPRESSION_DIR"/AcquiredPDF" > /dev/null 2>&1
mkdir $COMPRESSION_DIR"/EditedTXT" > /dev/null 2>&1
mkdir "StoreCompressionFile" > /dev/null 2>&1
: > $EXEC_SHELL
gawk -f AWKScripts/01_UPDATE/03_SubSystem/11_SubSystem_11.awk $PDFFILELIST $EDITTXTFILELIST > $EXEC_SHELL
sh $EXEC_SHELL

fgrep -q -v '0' TempRetCode/RetCode_*.txt
RetCode=$?
rm -rf TempRetCode > /dev/null 2>&1
test $RetCode -eq 0 && echo "Compression Directory Copy Process Failed." && echo "後続処理を実行せずに終了します。" && exit 99

tar -zcvf $COMPRESSION_FILE $COMPRESSION_DIR
RetCode=$?
test $RetCode -ne 0 && echo "Compression Process Failed." && echo "後続処理を実行せずに終了します。" && exit 99

rm -rf $COMPRESSION_DIR > /dev/null 2>&1

mkdir "TAR_GZHash" > /dev/null 2>&1
sha512sum $COMPRESSION_FILE > TAR_GZHash/$COMPRESSION_DIR".txt"
RetCode=$?
test $RetCode -ne 0 && echo "Hash Value Generate Process Failed." && echo "後続処理を実行せずに終了します。" && exit 99

echo "Compression Process Completed."
echo "Generated Compression File : "$COMPRESSION_FILE

echo "TB3DS Terminated Normally."
echo "TB3DSは正常終了しました。"

exit 0


