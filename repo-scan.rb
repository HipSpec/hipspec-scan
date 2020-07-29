require 'json'
require 'git'
require 'net/http'

puts "GITHUB_REPO: #{ENV['GITHUB_REPOSITORY']}"
puts "GITHUB_SHA: #{ENV['GITHUB_SHA']}"

g = Git.open('./')
data = g.grep('HIPSPEC').to_json
puts 'Writing scan to output file: hipspec-data.json'
File.write('./hipspec-data.json', data)

if ENV['HIPSPEC_WEBHOOK'].nil?
  puts 'Please Configure webhook: https://docs.hipspec.com'
else
  puts 'Post To HipSpec Webhook'
  uri = URI(ENV['HIPSPEC_WEBHOOK'])
  req = Net::HTTP::Post.new(uri, {
                              'Content-Type': 'application/json'
                            })

  req.body = {
    "GITHUB_REPO": ENV['GITHUB_REPOSITORY'],
    "GITHUB_SHA": ENV['GITHUB_SHA'],
    "scan_data": data
  }.to_json

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    response = http.request(req)
    puts response.read_body
  end
end
# Send the request

puts 'Closing...'
