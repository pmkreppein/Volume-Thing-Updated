require "csv"

#CLEAR SCREEN:
        #print "\e[2J\e[f"
###

list_of_files = CSV.read("cboe_file.csv", headers:true)
file_count = 0
symbols_calculated = []

#main loop at bottom

def calculate_curves(csv_file, symbol)
    #Create hashes for time values and final average storage
    time_hash = {}
    average_hash = {} 
    lines_read = 0
    cum_vol = 0.0
    #read each line of the incomming CSV file passed to calculate_curves
    for line in csv_file do
        stripped_time = line["time"][11..15]
        volume = line["volume"]
        lines_read += 1
        if !time_hash.has_key?(stripped_time)
            time_hash[stripped_time] = Array.new
        end
        time_hash[stripped_time].push(volume)
    end

    #Now all volumes sorted into a hash of arrays based on time
    time_hash.each{ |time, volumes|
        if !average_hash.has_key?(time)
            average_hash[time] = 0
        end
        #sum and average
        summed_volume = volumes.map{|v| v.to_f}.sum
        averaged_volume = summed_volume / volumes.size
        cleaned_average_volume = averaged_volume.round(1)
        average_hash[time] = cleaned_average_volume
    }



   

    #clean it up
    sorted_averages = average_hash.sort_by{|time, volume| time}

    #Save average hash to VolCurve file
    formatted_output_filepath = "./VolCurves/#{symbol}-VolCurve.csv"
    headers = ["time", "volume", "cum_vol"]
    CSV.open(formatted_output_filepath, "wb"){|csv| 
        csv << headers    
            sorted_averages.each {|row| 
                #Add cum_vol column here, with math
                #row[0] is time, row[1] is volume, and row[2] is the new cum_vol column
                cum_vol += row[1]
                row[2] = cum_vol
                csv << row

        }}


    puts "Total lines read for #{symbol} is #{lines_read}"
    #sleep(111)
end

for file in list_of_files do
    stripped_file = file[1].strip
    formatted_file_name = "./AlphavantageDownloads/#{stripped_file}.csv"
    csv_file = File.open(formatted_file_name)
    parsed_csv_file = CSV.read(csv_file, headers: true)
    #refer above for below :D
    unless parsed_csv_file[1] == nil
        calculate_curves(parsed_csv_file, stripped_file)
        symbols_calculated.push(stripped_file)
    end
    file_count += 1
end

puts "Total files processed is #{file_count}"
puts symbols_calculated

comparison_csv_header = ["Stock Symbol"]
CSV.open("compare_us.csv", "wb"){|csv| 
    csv << comparison_csv_header    
        symbols_calculated.each {|row| 
            row_array = Array(row)
            csv << row_array
    }}

puts "Done!"
