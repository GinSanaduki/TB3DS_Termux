#!/usr/bin/gawk -f
# 14_SubSystem_14.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/14_SubSystem_14.awk

{
	print $5 / 1024 / 1024;
	exit;
}

