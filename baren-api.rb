#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'baren'
require 'digest'
require 'tmpdir'
require 'json'

def path_to_png(md5)
  File.join(Dir.tmpdir, md5 + ".png")
end

set :public, File.dirname(__FILE__) + "/public"

get '/' do
  redirect to("/demo.html")
end

post '/api/pjs' do
  request.body.rewind  # in case someone already read it
  pjs = request.body.read
  md5 = Digest::MD5.hexdigest(pjs)
  path = path_to_png(md5)
  unless File.exist? path
    begin
      Baren::PjsTemplate.new{ pjs }.render(nil).tap do |png|
        File.open(path, "wb") do |f|
          f.print png
        end
      end
    rescue Baren::Error => e
      if request.xhr?
        content_type :json
        return [400, {:error => e.message}.to_json]
      else
        return [400, e.message]
      end
    end
  end
  if request.xhr?
    content_type :json
    {:url => to("/images/#{md5}.png")}.to_json
  else
    redirect to("/images/#{md5}.png")
  end
end

get '/images/*.png' do |md5|
  path = path_to_png(md5)
  if File.exist? path
    content_type :png
    File.open(path, "rb").read
  else
    raise Sinatra::NotFound
  end
end
