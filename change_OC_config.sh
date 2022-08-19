# !/usr/bin/env bash

function PatchFile_L () {
	local len=50
	local index=0
	local findstr=$1
	local findstr_L=""
	for i in `seq ${#findstr}`
	do
		findstr_L="${findstr_L}${findstr:i-1:1}\\x00"
		index=`expr ${index} + 1`
	done	
	for(( index=index+1;index<=len;index=index+1))
	do
	    findstr_L="${findstr_L}\\x00\\x00"
	done	
	echo "Find: ${findstr_L//\\/\\\\}"


	local repalce=$2
	local repalce_L=""
	index=0
	for i in `seq ${#repalce}`
	do
	    repalce_L="${repalce_L}${repalce:i-1:1}\\x00"
		index=`expr ${index} + 1`
	done
	for(( index=index+1;index<=len;index=index+1))
	do
	    repalce_L="${repalce_L}\\x00\\x00"
	done
	echo "Replace:${repalce_L//\\/\\\\}"
	

	perl -p -i -e "s/${findstr_L}/${repalce_L}/g"  "$3"
	if [ $? -ne 0 ]; then		
	    return 1
	fi
}

newconfigname=${1}
if [ ${newconfigname} != ${newconfigname//\//} ];then
	echo "你要修改的配置文件名含有\"/\""
	exit 1
fi

newconfigname=${1}
if [ ${newconfigname} != ${newconfigname//\\/} ];then
	echo "你要修改的配置文件名含有\"\\\""
	exit 1
fi

noenglish=$(echo ${1}|sed 's/[a-zA-Z0-9[:punct:]]//g')
if [ ${#noenglish} != 0 ];then
	echo "你要修改的配置文件名含有非英文字母"
	exit 1
fi

len=${#newconfigname}
if [ ${len} -gt 49 ]; then
	echo "你要修改的配置文件名太长了，不能超过49个字母"
	exit 1
fi

mkdir /tmp/$1
if [ $? != 0 ];then
	echo "你要修改的配置文件名不符合目录名规则"
	exit 1
fi
rm -rf /tmp/$1

echo "设置支持OC启动配置文件为: /${newconfigname}"
PatchFile_L "config.plist" "${newconfigname}" $2 
echo ""
