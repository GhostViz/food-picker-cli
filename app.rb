require "json"
require "http"
require "optparse"


# Place holders for Yelp Fusion's OAuth 2.0 credentials. Grab them
# from https://www.yelp.com/developers/v3/manage_app
CLIENT_ID = nil
CLIENT_SECRET = nil

# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"

DEFAULT_TERM = "food"
DEFAULT_LOCATION = "75240"
DEFAULT_SEARCH_LIMIT = 10

def bearer_token

  url = "#{API_HOST}#{TOKEN_PATH}"

  raise "Please set your CLIENT_ID" if CLIENT_ID.nil?
  raise "Please set your CLIENT_SECRET" if CLIENT_SECRET.nil?

  params = {
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
    grant_type: GRANT_TYPE
  }

  response = HTTP.post(url, params: params)
  parsed = response.parse

  "#{parsed['token_type']} #{parsed['access_token']}"
end

def findPlaces(term, location, searchLimit)
  url = "#{API_HOST}#{SEARCH_PATH}"
  params = {
    term: term,
    location: location,
    sort_by: "rating",
    price: "1",
    radius: 4825,
    open_now: true,
    limit: searchLimit
  }

  response = HTTP.auth(bearer_token).get(url, params: params)
  response.parse
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Example usage: ruby sample.rb search [options]"

  opts.on("-tTERM", "--term=TERM", "Search term") do |term|
    options[:term] = term
  end

  opts.on("-lLOCATION", "--location=LOCATION", "Search location") do |location|
    options[:location] = location
  end

  opts.on("-sSEARCH_LIMIT", "--limit=LIMIT", "Search limit") do |searchLimit|
    options[:searchLimit] = searchLimit
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

term = options.fetch(:term, DEFAULT_TERM)
location = options.fetch(:location, DEFAULT_LOCATION)
searchLimit = options.fetch(:searchLimit, DEFAULT_SEARCH_LIMIT).to_i

response = findPlaces(term, location, searchLimit)

if response["total"] < searchLimit
  searchLimit = response["total"]
end

puts "Picking from top #{searchLimit.to_s} results of #{response["total"]} total \nfor the term \"#{term}\" in location \"#{location}\""
puts "-----"
randomNumber = rand(searchLimit+1)-1
pickedBusiness = response["businesses"][randomNumber]
puts pickedBusiness["name"]
puts pickedBusiness["location"]["address1"].to_s + ' ' + pickedBusiness["location"]["address2"].to_s + ' ' + pickedBusiness["location"]["address3"].to_s
puts pickedBusiness["location"]["city"].to_s + ', ' + pickedBusiness["location"]["state"].to_s + ' ' + pickedBusiness["location"]["zip_code"].to_s
puts "Distance: %.1f miles" % (pickedBusiness["distance"]/1609.344)
puts "Rating: " + pickedBusiness["rating"].to_s
