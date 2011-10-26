require 'mechanize'
require "haml"

module Kvv
  COLORS = { "S5" => "#f69897", "S2" => "#9f66aa", "6" => "#7fc241", "3" => "#947138" }
  class Ride < Struct.new(:time, :line, :destination)
    def to_s
      "#{time}: #{line} -> #{destination}"
    end
  end
  
  def self.fetch_current(stop = "Haendelstrasse")
    url = "http://213.144.24.66/kvv/XSLT_DM_REQUEST"

    agent = Mechanize.new
    page = agent.post(url)
    f = page.forms.first
    f.place_dm = "Karlsruhe"
    f.name_dm = stop
    
    page = agent.submit(f, f.buttons.first)
    f = page.forms.first
    f.field_with(:name => 'dmLineSelection').select_all
    
    page = agent.submit(f)
    trains = page.root.css("tr:nth-child(even)").to_a
    trains.reject! { |r| r.css(".dmDeparture").empty? }
    i = 0
    trains.reject! { |r| (i += 1).odd? }
    
    trains.map do |row|
      Ride.new.tap do |ride|
        row.css("td").each_with_index do |col, i|
          case i
          when 0
            ride.time = Time.parse(col.css(".dmDeparture").first.content.gsub("\302\240", " ").strip)
          when 2
            ride.line = col.content.strip.match(/.\d*/)[0]
          when 3
            puts col.content
            ride.destination = col.content.strip
          end
        end
      end
    end
  end
end