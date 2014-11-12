require "json"
require "open-uri"
require "yaml"
require "mysql2"
data = YAML.load(File.open("database.yml"))
localhost = data["development"]["host"]
username = data["development"]["username"]
database = data["development"]["database"]
password = data["development"]["password"]
link = Mysql2::Client.new(:host => "#{localhost}", :username => "#{username}", :password => "#{password}", :database => "#{database}")

def ban_word(word)
    target_word=""
    for i in 0..word.length-1 do
      if i != word.length-1
       if /[0-9a-zA-Z\u0391-\uFFE5]/.match(word[i])
        target_word=target_word + word[i] +'\\\s*'
       end
      else
       if /[0-9a-zA-Z\u0391-\uFFE5]/.match(word[i])
         target_word= target_word + "#{word[i]}"
       end
       end
    end
    target_word
end

#f = File.open("word.txt")
#f.each_line do |word|
#  word = word.chomp
# # p word
#  link.query("insert into ban_words(word) values ('#{word}') ")
#  p "insert into ban_words(word) values ('#{word}')"
#  p "success"
#end

words = link.query("select * from ban_words")

words.each do |word|
   new_ban_word = ban_word(word["word"])
   p new_ban_word
   link.query("update ban_words set zz_word = '#{new_ban_word}' where id =#{word["id"]}")
   p "success"
end 

