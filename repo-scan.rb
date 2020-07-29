require 'json'
require 'git'
require 'net/http'

puts "GITHUB_REPO: #{ENV['GITHUB_REPOSITORY']}"
puts "GITHUB_SHA: #{ENV['GITHUB_SHA']}"

g = Git.open('./')
data = g.grep('HIPSPEC').to_json
puts 'Writing scan to output file: hipspec-data.json'
File.write('./hipspec-data.json', data)

if ENV['HIPSPEC_WEBHOOK'].present?
  puts 'Post To HipSpec Webhook'
  # Posts data to HIPSPEC_WEBHOOK
  uri = URI.parse(ENV['HIPSPEC_WEBHOOK'])
  header = { 'Content-Type': 'text/json' }

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = {
    GITHUB_REPO: ENV['GITHUB_REPOSITORY'],
    GITHUB_SHA: ENV['GITHUB_SHA'],
    scan_data: data
  }
else
  puts 'Please Configure webhook: https://docs.hipspec.com'
end
# Send the request
response = http.request(request)

puts 'Closing...'
