#!/usr/bin/gawk -f
# 10_SubSystem_10.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/10_SubSystem_10.awk

BEGIN{
	print "#!/bin/sh";
}

{
	Tex = $0;
	gsub("EditedTXT/","TempRetCode/RetCode_",Tex);
	print "test -s "$0" && echo \""$0" IS NOT EMPTY FILE.\" > "Tex" &";
	print "test ! -s "$0" && echo \""$0" IS EMPTY FILE.\" > "Tex" &";
}

END{
	print "wait";
	print "exit 0 ";
}

