require 'csv'
require 'json'

# def temp()
	
# 	lines = IO.readlines("File2.csv")
# 	puts "=================================="
# 	puts "#{lines.first.class}"

# 	out_file = File.open("Out1.json","w")
# 	flag = true
# 	head_arr=[]
# 	out_file.write("{\n")

# 	IO.each_with_index("File2.csv") do |line,index|
# 		puts line.class,index

# 		if flag
# 			#print count,"\n"
# 			head_arr=line.split(",")
# 			#count=count+1
# 			flag = false

# 			# print "+++++++++++++++++++++++++++"
# 			# print "#{head_arr} \n\n\n"
# 			# print "==========================="

# 		else
# 			data_arr=line.split(",")
			
# 			# print "+++++++++++++++++++++++++++"
# 			# print "#{data_arr} \n\n\n"
# 			# print "==========================="

# 			h=Hash[head_arr.zip(data_arr)]
# 			out_file.write(h)
# 			if line==lines.last
# 				out_file.write("\n")
# 			else
# 				out_file.write(",\n")
# 			end
# 			#print h
# 		end
# 		out_file.write("}\n")
# 	end



# 	# IO.foreach("File2.csv") do |line|
# 	# 	puts "#{line}"
# 	# end

# end

def  csv_json(from,to,header=true)

	if !File.file?(from)
		puts "Input File does not exist "
		return
	end
	if to.nil?||to.empty?
		to="/tmp/#{from.split(".")[0]}.json"
	end
	#puts to
	
	out_file = File.open(to,"w")
	out_file.write("{\n")

	head_arr=[]
	head_fill = true
	#data_fill = false

	CSV.foreach(from ,headers:false) do |row|
		if head_fill
			if header 
				head_arr=row.to_a
				head_fill = false
			else
				head_arr=(1..row.to_a.size).map{|i| "COLM_"+i.to_s }
				head_fill=false
			end
		#end
		else
		#if data_fill
			data_arr=row.to_a
			
			h=Hash[head_arr.zip(data_arr)].to_json
			out_file.write(h)
			out_file.write(",\n")
		end


		#data_fill=true if !head_fill && !data_fill
	end
	out_file.seek(-2, IO::SEEK_END)
	out_file.write("\n}\n")	
end
csv_json("File2.csv","out2.json")







# def  csv_json()
# 	out_file = File.open("Out2.json","w")
# 	flag = true
# 	head_arr=[]

# 	ipfile = CSV.read("File2.csv")
# 	print ipfile.size
# 	out_file.write("{\n")
	
# 	ipfile.each do |line|
# 		if flag
# 			#print count,"\n"
# 			head_arr=line
# 			#count=count+1
# 			flag = false
# 			# print "+++++++++++++++++++++++++++"
# 			# print "#{head_arr} \n\n\n"
# 			# print "==========================="
# 		else
# 			data_arr=line
# 			# print "+++++++++++++++++++++++++++"
# 			# print "#{data_arr} \n\n\n"
# 			# print "==========================="
# 			h=Hash[head_arr.zip(data_arr)]
# 			out_file.write(h)
# 			if line==ipfile[ipfile.size-1]
# 				out_file.write("\n")	
# 			else
# 				out_file.write(",\n")
# 			end
# 		end
# 	end
# 	out_file.write("}\n")
# end
#  csv_json()
