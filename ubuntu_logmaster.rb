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
			for i in 0..9
				if(line[2] =~ /^0#{i}/)
					tab[i] +=1
				end
			end
			for i in 10..23
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


	def occurence
		count = {}
		@file.each do |line|
			line = line.split(/\d+:\d+:\d+/)
			line[1] = line[1].split
			line[1].shift if line[1][0] =~ /gojira/	#user name
			if count.has_key?(line[1][0])
				count[line[1][0]] += 1
			else
				count[line[1][0]] = 1
			end
		end

		count.each do |key, val|
			puts "#{val} times #{key}"
		end
	end
end


file = File.open(ARGV.shift)
script = LogMaster.new(file)

print "\nOPTIONS:\noc -occurance of logs by hour\nfr -frequency of logs\n=> "
STDOUT.flush
opt = gets.chomp

if opt == "oc"
	script.occurence
elsif opt == "fr"
	script.frequency
else
	p "arg error"
end
