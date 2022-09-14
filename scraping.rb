require 'open-uri'
require 'nokogiri'
require 'csv'

def scraping(url, client)
  create_tables(client)

  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  arr = []
  obj = []
  doc.xpath("//tbody").each_with_index do |el, i|
    str = ''
    tested = ''
    pos = ''
    el.text.split("\n").reject { |ele| ele == "" }.each_with_index do |text, i|


      case i % 13
      when 0
        str = text
      when 1
        tested = text
      when 2
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      when 3
        tested = text
      when 4
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      when 5
        tested = text
      when 6
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      when 7
        tested = text
      when 8
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      when 9
        tested = text
      when 10
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      when 11
        tested = text
      when 12
        pos = text
        obj << {:"Week" => str, :"Spec Tested" => tested, :"% Pos" => pos}
      end
    end
  end
  obj.each_with_index do |el, i|
    case i % 6
      when 0
        client.query("INSERT INTO scraping_total_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      when 1
        client.query("INSERT INTO scraping_0to4_years_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      when 2
        client.query("INSERT INTO scraping_5to17_years_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      when 3
        client.query("INSERT INTO scraping_18to49_years_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      when 4
        client.query("INSERT INTO scraping_50to64_years_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      when 5
        client.query("INSERT INTO scraping_65plus_years_luiz VALUES ('#{el[:"Week"]}', '#{el[:"Spec Tested"]}', '#{el[:"% Pos"]}')")
      end
  end
  print "Done!"
end

def create_tables (client)
  begin
    client.query("CREATE TABLE scraping_total_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
    client.query("CREATE TABLE scraping_0to4_years_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
    client.query("CREATE TABLE scraping_5to17_years_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
    client.query("CREATE TABLE scraping_18to49_years_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
    client.query("CREATE TABLE scraping_50to64_years_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
    client.query("CREATE TABLE scraping_65plus_years_luiz (
      week VARCHAR(255),
      spec_tested VARCHAR(255),
      percentage_pos VARCHAR(255)
    )")
  rescue
    puts "Table already created"
  end
end