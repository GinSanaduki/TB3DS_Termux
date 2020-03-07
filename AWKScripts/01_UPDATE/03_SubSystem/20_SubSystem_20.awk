#!/usr/bin/gawk -f
# 20_SubSystem_20.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/20_SubSystem_20.awk -v StandbyStart=$StandbyStart -v PreExecTime=$PreExecTime

BEGIN{
	StandbyStart = StandbyStart + 0;
	PreExecTime = PreExecTime + 0;
	if(StandbyStart < 1){
		StandbyStart = systime();
	}
	if(PreExecTime < 1){
		PreExecTime = 80;
		cmd = "uname -a";
		while(cmd | getline esc){
			break;
		}
		close(cmd);
		split(esc,escArrays);
		OS_Name = escArrays[length(escArrays)];
		delete escArrays;
		if(OS_Name == "Android"){
			PreExecTime = PreExecTime * 6 * 1.4;
		}
	}
	print StandbyStart + PreExecTime - 2;
}

