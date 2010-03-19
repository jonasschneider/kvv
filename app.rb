require 'rubygems'
require 'kvv'
require 'sinatra'

get "/" do
  content_type "text/plain", 'charset' => 'utf-8'
  "".tap do |buf|
    Kvv.fetch_current.each do |ride|
      buf << "- #{ride.to_s}\n"
    end
  end
end
