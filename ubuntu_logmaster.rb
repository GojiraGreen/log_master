#! ruby

# 11.04.14

########################
# For system logs only #

class LogMaster
  def initialize(file)
    @file = file
  end

  def frequency
    tab = Array.new(24){|x| x=0}

    @file.each do |line|
      line = line.split
      (0..9).each do |i|
        if(line[2] =~ /^0#{i}/)
          tab[i] +=1
        end
      end

      (10..23).each do |i|
        if(line[2] =~ /^#{i}/)
          tab[i] +=1
        end
      end
    end

    for i in 0..23
      if(tab[i] != 0)
        puts "#{tab[i]} timestamps at #{i} o'clock.\n"
      end
    end
  end


  def occurence(opt=nil)
    count = {}
    @file.each do |line|
      line = line.split(/\d+:\d+:\d+/)[1]
      line = line.split
      line.shift if line[0] =~ /gojira/	#user name
      unless opt.nil?
        line[0].slice!(/\[.*\]/)
      end
      if count.has_key?(line[0])
        count[line[0]] += 1
      else
        count[line[0]] = 1
      end
    end

    count.each do |key, val|
      puts "#{val} times #{key}"
    end
  end
end


file = File.open(ARGV.shift)
script = LogMaster.new(file)

print "\nOPTIONS:\nocu -occurance of logs by hour\nocn -occurance with no PID\nfrq -frequency of logs\n=> "
STDOUT.flush
opt = gets.chomp

if opt == "ocu"
  script.occurence
elsif opt == "ocn"
  script.occurence(true)
elsif opt == "frq"
  script.frequency
else
  p "arg error"
end
