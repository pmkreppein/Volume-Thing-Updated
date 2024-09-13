require "csv"
require 'open-uri'


cboe_file = "./cboe_file.csv"
files_downloaded_total = 0


CSV.foreach(cboe_file, headers: true) do |row|
    formatted_url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{row["Stock Symbol"]}&interval=5min&slice=year1month1&slice=year1month2&apikey=Demo&datatype=csv"
    download = URI.open(formatted_url)
    IO.copy_stream(download, "./AlphavantageDownloads/#{row["Stock Symbol"]}.csv")
    puts "Downloaded file for #{row["Stock Symbol"]}"
    files_downloaded_total += 1
    puts files_downloaded_total
end

puts "Total files downloaded: #{files_downloaded_total}"
