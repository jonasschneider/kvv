require 'rubygems'
require 'sinatra'
require 'haml'
require "sass"

require './kvv'

before do
  content_type 'text/html', :charset => 'utf-8'
end

helpers do
  def line_style(line)
    attrs = { :style => "background-color:#{Kvv::COLORS[line] || "#ccc"};" }
    if line[0, 1] == 'S'
      attrs[:class] = 'round'
    end
    attrs
  end
end

set :haml, :format => :html5

get "/" do
  @rides = Kvv.fetch_current.select{ |ride| ride.time >= Time.now}
  haml :list
end

get "/style.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

run Sinatra::Application
