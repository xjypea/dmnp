#!/bin/bash
source ./.env
###为项目编号
count=0
for i in "${project[@]}"; do 
	((count++))
	number[$count]=$i;
done
case $1 in
		-q)
			while [[ 1 ]]; do
				# 循环数组
				for(( i=1;i<=${#number[@]};i++)) do
				# 打印数组
				echo $i.${number[i]};
				done;
				#输入选择
				read -p "Please enter the project: " num

				if [ ! ${path[${number[num]}]} ]; then  
				  echo "请选择正确的项目!!"  
				  exit 1
				else 
				  cd ${path[${number[num]}]} > /dev/null 2>&1 || {
				  	echo "文件目录不存在，请检查配置！！"
				  	exit 1
				  }
				fi  
				# 执行队列
				if [ ! ${queue[${number[num]}]} ]; then  
				  eval $queueDefault
				else 
				  eval ${queue[${number[num]}]}
				fi  
				read -p "do you want to exit code(y|n): " bool
				case $bool in
						n)
							;;
						*)
						exit 0	
				esac
			done
			;;
		-c)
			thinkphp="location / {\n\t\tindex index.php;\n\t\tif (!-e \$request_filename) {\n\t\t\trewrite  ^(.*)$  /index.php?s=\$1  last;\n\t\t\tbreak;\n\t\t}\n\t}"
			laravel="location / {\n\t\ttry_files \$uri \$uri/ /index.php?$\query_string;\n\t}"
			while [[ 1 ]]; do
				# 循环数组
				for(( i=1;i<=${#number[@]};i++)) do
				# 打印数组
				echo $i.${number[i]};
				done;
				read -p "Please enter the project: " num

				if [ ! ${path[${number[num]}]} ]; then  
				  echo "请选择正确的项目!!"  
				  exit 1
				else 
				  if [ ${serverName[${number[num]}]} ]; then
				  	if [ ! ${fileName[${number[num]}]} ] && [ ! ${serverName[${number[num]}]} ]; then
				  		echo "请在env内填写filename serverName字段"
				  		exit 0
				  	fi
				  	fileName=${fileName[${number[num]}]}
					serverName=${serverName[${number[num]}]}	
				  else
				  	 fileName=${project[${number[num]}]}"_"${fileExtension}
				  	 serverName=${project[${number[num]}]}"."${serverExtension}
				  fi	
				  path=${path[${number[num]}]//\\/\/}
				fi
				
				if [ ! -f  "/etc/nginx/conf.d/${fileName}.conf" ];then
					echo "配置文件不存在,创建文件~_~"
					cp /etc/nginx/conf.d/localhost.conf /etc/nginx/conf.d/$fileName.conf
					sed -i "s|;*/www/.*|/www/${path};|i" /etc/nginx/conf.d/$fileName.conf
					sed -i "s|;*server_name.*|server_name  ${serverName};|i" /etc/nginx/conf.d/$fileName.conf
					if [  ${static[${number[num]}]} ] && [ ${static[${number[num]}]} = thinkphp ]; then
						sed -i "s|;*location\s\/\s*{\s*}$|${thinkphp}|i" /etc/nginx/conf.d/$fileName.conf
					elif [  ${static[${number[num]}]} ] &&  [ ${static[${number[num]}]} = laravel ]; then
						sed -i "s|;*location\s\/\s*{\s*}$|${laravel}|i" /etc/nginx/conf.d/$fileName.conf
					fi
					if [ ${php[${number[num]}]} ];then
						sed -i "s|;*php:9000;|${php[${number[num]}]}:9000;|i" /etc/nginx/conf.d/$fileName.conf
					fi	
					echo "配置文件创建成功-_-"
					echo "重启nginx中。。。"
					nginx -s reload
					echo "重启成功。。。"
				else
					echo "配置文件存在，退出~_~"
				fi
				read -p "do you want to exit code(y|n): " bool
				case $bool in
						n)
							;;
						*)
						exit 0	
				esac
			done
			;;	
		*)
		echo -e "-c      此参数要在nginx容器中使用，配置nginx网站配置\n-q      此参数为消息队列启动参数,需要在php容器中使用"	
	esac
