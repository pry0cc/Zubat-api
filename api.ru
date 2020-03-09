#!/usr/bin/env ruby
require "sinatra"
require "mongo"
require "json"
require "puma"

mongo_url = ENV["mongo_url"]
database = ENV["db"]
collection = ENV["collection"]
set(:environment, :production)
set(:bind, "0.0.0.0")
set(:port, 8081)
set(:server, "puma")
set(:logging, false)
set(:dump_errors, false)

class Zubat
  def initialize(conn_str, database, collection_str)
    @client = Mongo::Client.new([conn_str],     :database => database)
    @collection = @client[collection_str]
  end

  def get_domain_data(domain)
    resp = @collection.find({:"domain_index" => domain})
    data = []

    resp.each do |item|
      data.push(item)
    end

    return data
  end

  def get_subdomains(domain)
    subdomains = []
    resp = @collection.find({:"domain_index" => domain})

    resp.each do |result|
      subdomains.push(result["name"])
    end

    return subdomains
  end

  def get_domain_indexes
    domain_indexes = []
    resp = @collection.distinct("domain_index")

    resp.each do |result|
      domain_indexes.push(result)
    end

    return domain_indexes
  end
end

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

run(Sinatra::Application.run!)
