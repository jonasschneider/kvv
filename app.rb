require 'rubygems'
require 'kvv'
require 'sinatra'

get "/" do
  @rides = Kvv.fetch_current.each
  haml :list
end
