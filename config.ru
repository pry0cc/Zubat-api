#!/usr/bin/env falcon --verbose serve -c
require "sinatra/base"
require "mongo"
require "json"
require "falcon"
require "./zubat.rb"

class MyApp < Sinatra::Base
  mongo_url = ENV["mongo_url"]
  database = ENV["db"]
  collection = ENV["collection"]
  zubat = Zubat.new(mongo_url, database, collection)

  get("/domains/") do
    return JSON.pretty_generate(zubat.get_domain_indexes)
  end

  get("/domains/:domain") do
    return JSON.pretty_generate(zubat.get_domain_data(params[:domain]))
  end

  get("/domains/:domain/subdomains") do
    return JSON.pretty_generate(zubat.get_subdomains(params[:domain]))
  end
end

use(MyApp)
run(lambda { |env| [404, {}, []] })
