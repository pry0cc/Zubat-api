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
