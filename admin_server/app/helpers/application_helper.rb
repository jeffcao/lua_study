#encoding: utf-8

module ApplicationHelper
  def create_update_package(cur_ver, effect_mode, apply_app_id, res_pkg_name)
    #cur_ver = "2.3.1"
    #res_pkg_name = "resources.zip"
    Rails.logger.info("[create_update_package]")
    old_w_dir = Dir.pwd
    #ser_pkg_path = "/Users/jeffcao/workspace/ruby_test"
    # ser_pkg_path = ResultCode::UPDATE_PACKAGE_PATH
    ser_pkg_path = SystemSetting.find_by_setting_name("apk_res_package_location").setting_value
    ver_array = cur_ver.split(".")
    ver_array = /(\d+\.\d+)\.(\d+)/.match(cur_ver)
    ver_cur_full_path = "#{ser_pkg_path}/#{ver_array[1]}/#{ver_array[2]}"
    Dir.chdir(ver_cur_full_path)
    Rails.logger.info("[create_update_package1]")

    cur_ver_path = "./"
    cur_res_path =  "resources"
    tmp_res_path = "assets"
    res_pkg_full_name = "#{res_pkg_name}"
    files_list_name = "files_list_name.txt"
    Rails.logger.info("[create_update_package2]")
    Rails.logger.info("res_pkg_full_name#{res_pkg_full_name}")

    `rm -rf #{tmp_res_path}`
    `rm -rf #{cur_res_path}`
    `unzip #{res_pkg_full_name}`
    `mv #{tmp_res_path} #{cur_res_path}`

    smaller_ver_array = ["2.1", "2.2"]
    sql = "select * from resource_updates where apply_app_id like '%#{apply_app_id}%' and version like '#{ver_array[1]}%'
                  and version != '#{cur_ver}'"
    Rails.logger.debug("sql#{sql}")

    u_resources = ResourceUpdate.find_by_sql(sql)
    # if u_resources.size == 0 and ver_array[2].to_i != 0
    #   s_ver = "#{ver_array[1]}.0"
    #   package_and_record(cur_res_path, files_list_name, cur_ver, s_ver,true, effect_mode, apply_app_id)
    if u_resources.size > 0
      u_resources.each do |u_r|
        s_ver = u_r.version
        s_ver_array = s_ver.split(".")
        s_ver_array = /(\d+\.\d+)\.(\d+)/.match(s_ver)
        s_res_path = "../#{s_ver_array[2]}/resources"
        Dir.chdir("#{ser_pkg_path}/#{s_ver_array[1]}/#{s_ver_array[2]}")
        `rm -rf #{tmp_res_path}`
        `rm -rf #{cur_res_path}`
        `unzip #{u_r.name}`
        `mv #{tmp_res_path} #{cur_res_path}`
        Dir.chdir(ver_cur_full_path)
        `diff -Prq #{s_res_path} #{cur_res_path} |awk '{print $4}' |grep #{cur_res_path} > #{files_list_name}`
        package_and_record(cur_res_path, files_list_name, cur_ver, s_ver,false, effect_mode, apply_app_id)
      end
    end
    if File.exist?files_list_name
      #File.delete(files_list_name)
    end
    Dir.chdir(old_w_dir)
  end

  def package_and_record(cur_res_path, files_list_name, cur_ver, s_ver,all_files, effect_mode, apply_app_id)

    # ver_array = cur_ver.split(".")
    # ver_array = /(\d+\.\d+)\.(\d+)/.match(cur_ver)
    # s_ver_array = s_ver.split(".")
    # s_ver_array = /(\d+\.\d+)\.(\d+)/.match(s_ver)
    # up_pkg_name = "#{s_ver}-#{cur_ver}-update.zip"
    Rails.logger.debug("package_and_record_s_ver=>#{s_ver}")
    Rails.logger.debug("package_and_record_cur_ver=>#{cur_ver}")
    begin_string = s_ver.split(".")
    begin_string = begin_string[begin_string.size-1]
    last_string = cur_ver.split(".")
    last_string = last_string[last_string.size-1]
    up_pkg_name = "#{begin_string}#{last_string}#{Time.now.to_i}.zip"
    Rails.logger.debug("package_and_record_up_pkg_name=>#{up_pkg_name}")
    Rails.logger.debug("package_and_record_cur_res_path=>#{cur_res_path}")
    Rails.logger.debug("package_and_record_files_list_name=>#{files_list_name}")

    if all_files
      Rails.logger.debug("begin zip one #{up_pkg_name}")
      `zip -r #{up_pkg_name} #{cur_res_path}`
    else
      Rails.logger.debug("begin zip two #{up_pkg_name}")
      `zip -r #{up_pkg_name} #{cur_res_path} -i@./#{files_list_name}`
    end
    p up_pkg_name
    unless File.exist?(up_pkg_name)
      Rails.logger.debug("Failed to create #{up_pkg_name}")
    end

    md5 = Digest::MD5.hexdigest(File.read(up_pkg_name))
    p md5

    file = File.new(up_pkg_name)
    s_code = file.read(20)
    file.close
    p s_code

    file = File.new(up_pkg_name, "r+")
    file.write("12345678901234567890")
    Rails.logger.debug("write file")

    file.close

    s_md5 = Digest::MD5.hexdigest(File.read(up_pkg_name))
    p s_md5
    Rails.logger.debug("md5 file")

    up = UpdatePackage.new
    up.file_name = up_pkg_name
    up.apply_app_id = apply_app_id
    up.effect_mode = effect_mode
    up.version = "#{s_ver}-#{cur_ver}"
    up.md5 =  md5
    tmp_code = []
    s_code.each_byte do |c|
      tmp_code.push(c)
    end
    s_code = tmp_code.join(",")
    up.specifical_code = s_code
    up.s_md5 = s_md5
    Rails.logger.debug("save file")

    up.save
  end

  def current_ability
    @current_ability ||= Ability.new(current_super_user)
  end

end
