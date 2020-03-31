require "csv"
require "date"

initial_date = Date.parse('2020-01-22')
i = 0

out_file = File.new("./csv/locations/locations.csv", "w")
out_file.close
CSV.open("./csv/locations/locations.csv", "wb") do |csv|
  csv << ["province_state", "country", "code", "lat", "long"]
  i = 0
  CSV.foreach("time_series_19-covid-Confirmed.csv", :row_sep => :auto, :col_sep => ",", return_headers: false) do |row|
    region = ""
    country = ""
    region = row[0].gsub(/ /, "").gsub(/,/, "").gsub(/\*/, "").gsub(/\./, "") unless row[0].nil?
    country = row[1].gsub(/ /, "").gsub(/,/, "").gsub(/\*/, "").gsub(/\./, "") unless row[1].nil?
    code = region + country
    csv << [row[0], row[1], code, row[2], row[3]] if i > 0
    i = i + 1
  end
end

i = 0
filename = "./csv/countries-data/countries-data.csv"
out_file = File.new(filename, "w")
out_file.close
CSV.open(filename, "wb") do |csv|
  csv << ["region", "date", "confirmed", "death", "recovered"]
end
CSV.foreach("time_series_19-covid-Confirmed.csv", :row_sep => :auto, :col_sep => ",", return_headers: false) do |row|
  if i > 0
    country = ""
    country = row[0] unless row[0].nil?
    country = country + row[1] unless row[1].nil?
    country = country.gsub(/ /, "").gsub(/,/, "").gsub(/\*/, "").gsub(/\./, "")

    CSV.open(filename, "a") do |csv|
      date_counter = 0
      row[4..-1].each do |point|
        csv << ["#{country}", "#{initial_date + date_counter}", "#{point}", "0", "0"]
        date_counter = date_counter + 1
      end
    end
  end
  i = i + 1
end
