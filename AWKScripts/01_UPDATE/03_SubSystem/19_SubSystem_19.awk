#!/usr/bin/gawk -f
# 19_SubSystem_19.awk
# gawk -f AWKScripts/01_UPDATE/03_SubSystem/19_SubSystem_19.awk -v START_TIME=$START_TIME -v ExecTime=$ExecTime

BEGIN{
	# START_TIME = START_TIME + 0;
	ExecTime = ExecTime + 0;
	# if(START_TIME < 1){
	START_TIME = systime();
	# }
	if(ExecTime < 1){
		ExecTime = 80;
		cmd = "uname -a";
		while(cmd | getline esc){
			break;
		}
		close(cmd);
		split(esc,escArrays);
		OS_Name = escArrays[length(escArrays)];
		delete escArrays;
		if(OS_Name == "Android"){
			ExecTime = ExecTime * 6 * 1.4;
		}
	}
	print "完了予定時刻 : "strftime("%Y年%m月%d日 %H時%M分%S秒",START_TIME + ExecTime);
}

