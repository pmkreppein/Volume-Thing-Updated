require "csv"
require 'json'
require 'net/http'
require 'uri'
require "date"
require "pry"

#cboe_file = "compare_us8.csv"
cboe_file = "./cboe_file.csv"
quotes_downloaded_total = 0
args = ARGV
time_to_check = args[0]
comparisons_made = 0
volume_comparisons = []


def look_and_return_vcurve_volume(symbol, time_to_compare)
    vcurve_file = "./VolCurves/#{symbol}-VolCurve.csv"
    CSV.foreach(vcurve_file, headers: true) do |row|
        if row["time"] == time_to_compare
            return row["cum_vol"].to_f.round(2)
         end
      end
end


CSV.foreach(cboe_file, headers: true) do |row|
    symbol = row['Stock Symbol']
    formatted_url = "https://cloud.iexapis.com/stable/stock/#{symbol}/quote?token="
    uri = URI.parse(formatted_url)
    response = Net::HTTP.get_response(uri)
    quote = JSON.parse(response.body)
    ############################################
    ##VOLUME FIELD CHANGED FOR AFTER HOURS TESTING below##
    ## code before:
    ### volume = quote["latestVolume"]
    ##
    ############################################
    
    volume = quote["previousVolume"]
    company_name = quote["companyName"]
    cum = look_and_return_vcurve_volume(symbol, time_to_check)
    difference_in_volume = volume.to_f.round(2) / cum.to_f.round(2)
    percent_difference = difference_in_volume * 100
    rounded_difference = percent_difference.round(2)
    this_symbol_hash = {"symbol": symbol, "company_name": company_name, "quoted_volume": volume, "normal_cum_volume": cum, "difference_in_volume": rounded_difference.to_f}

    volume_comparisons << this_symbol_hash

    
    
    

    quotes_downloaded_total += 1
    #puts volume_comparisons
    puts quotes_downloaded_total
    #sleep(3)
end



sorted_comparisons = volume_comparisons.sort_by!{|k, v| -k[:difference_in_volume]}

puts "Writing File...."

comparison_output_filename = "#{(DateTime.now).strftime('%d-%m-%Y %I%M %p')} VolComp.csv"
comparison_output_filepath = "./Comparisons/#{comparison_output_filename}"

comparison_output_csv_header = ["Stock Symbol", "Company Name", "Quoted Volume", "Normal Volume", "Difference Percentage"]
CSV.open(comparison_output_filepath, "wb"){|csv| 
    csv << comparison_output_csv_header    
        sorted_comparisons.each {|row| 
          csv << row.values
        } 
    }

puts "All done!  View file at #{comparison_output_filepath}"
