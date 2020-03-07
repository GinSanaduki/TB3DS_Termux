#!/usr/bin/gawk -f
# 18_SubSystem_18.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/18_SubSystem_18.awk

{
	Remainder = $0 % 8;
	if(Remainder < 1){
		Remainder = 1;
	}
	exit Remainder;
}

