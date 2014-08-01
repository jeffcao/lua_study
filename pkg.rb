require 'Find'
#remove file
def delete_file(filename, group)
	p "#{group}:remove file #{filename}"
	`rm #{filename}`
end

#建立多级目录
def mkdirs(path)
	p "mkdirs:#{path}"
    if(!File.directory?(path))
        if(!mkdirs(File.dirname(path)))
            return false;
        end
        Dir.mkdir(path)
    end
    return true
end

#Charge.xml, Config.xml, CosumeCodeInfo.xml, d_data_store.dat s_data_store.dat(移动sdk) 
#SkyPayInfo.xml(斯凯), ZYF_ChannelID（斯凯）, SourceConfig（乐易付）
configs = {
	"letu"=>["proj.android/res/values/lt-colors.xml",
		"proj.android/res/values/lt-styles.xml"],
	"mili"=>[],
	"miliuu"=>[],
	"wiipay"=>["proj.android/assets/alipay_plugin_20120428msp.apk",
		"proj.android/assets/UPPayPluginEx.apk"],
	"leyifu"=>["proj.android/res/drawable/hfb_*", 
		"proj.android/res/drawable-hdpi/hfb_*", 
		"proj.android/res/layout/hfb_*", 
		"proj.android/res/values/hfb_*",
		"proj.android/assets/astep.bin",
		"proj.android/libs/armeabi/libbsjni.so",
		"proj.android/assets/SourceConfig"],

	"cmcc"=>["proj.android/res/drawable-hdpi/gc_*", 
		"proj.android/res/values/g_*", 
		"proj.android/assets/CMGC/*", 
		"proj.android/assets/OpeningAnimation/*",
		"proj.android/libs/armeabi/libmegjb.so",
		"proj.android/assets/Charge.xml",
		"proj.android/assets/Config.xml",
		"proj.android/assets/ConsumeCodeInfo.xml",
		"proj.android/assets/d_data_store.dat",
		"proj.android/assets/s_data_store.dat"],

	"sikai"=>["proj.android/assets/com.skymobi.pay.iplugin_V4003.apk", 
		"proj.android/assets/Alipay_msp_online.apk",
		"proj.android/assets/SkyPayInfo.xml",
		"proj.android/assets/ZYF_ChannelID"],

	"anzhi"=>["proj.android/assets/AnzhiPayments.apk"]
	}

def dir_name(file_name)
	/.*\//.match(file_name)[0]
end

def bak_file(cp_file_name)
	dir_name = dir_name(cp_file_name)
	mkdirs("sdk_res_bak/#{dir_name}")
	p "cp #{cp_file_name} sdk_res_bak/#{dir_name}"
	`cp #{cp_file_name} sdk_res_bak/#{dir_name}`
end

def copy_file(cp_file_name)
	dir_name = dir_name(cp_file_name)
	mkdirs(dir_name)
	p "cp sdk_res_bak/#{cp_file_name} #{dir_name}"
	`cp sdk_res_bak/#{cp_file_name} #{dir_name}`
end

def copy_all_resources(configs)
	configs.each do |k, v|
		v.each do |file|
			dir = dir_name(file)

			if file.end_with?("*")
				prefix = file[dir.length ... file.length-1]
				p "prefix:#{prefix}"

				mkdirs(dir)
				Find.find(dir) do |path|
					if !prefix or path[dir.length, path.length].start_with?(prefix)
						p "find file #{path}"
						bak_file(path)
					end
				end
			else
				bak_file(file)
			end
		end
	end
end
#第一步，执行这行代码把所有的资源拷贝到外面去
copy_all_resources(configs)

#第二步，把所有sdk的资源都删除
def delete_all_resources(configs)
	configs.each do |k, v|
		v.each do |file|
			delete_file(file, k)
		end
	end
end
delete_all_resources(configs)

#第三步，把需要的sdk资源文件从另外一个文件夹copy过来
def copy_targeted_resources(configs)
	paytype = IO.read("proj.android/res/raw/paytype").chomp
	p "paytype is #{paytype}"
	configs[paytype].each do |file|
		copy_file(file)
	end
end
copy_targeted_resources(configs)