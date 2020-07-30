require 'json'
require 'git'
require 'net/http'

git_server_url = ENV['GITHUB_SERVER_URL'] || 'not_provided'
git_repo = ENV['GITHUB_REPOSITORY'] || 'not_provided'
git_sha = ENV['GITHUB_SHA'] || 'not_provided'
webhook_target = ENV['HIPSPEC_WEBHOOK']

puts "GITHUB_SERVER_URL: #{git_server_url}"
puts "GITHUB_REPO: #{git_repo}"
puts "GITHUB_SHA: #{git_sha}"

g = Git.open('./')
data = g.grep('HIPSPEC-')

data = data.map { |k, v| { name: k, locations: v.to_a } }
data = data.to_json

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
    "server_url": git_server_url,
    "repo": git_repo,
    "sha": git_sha,
    "scan_data": data
  }.to_json

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    response = http.request(req)
    puts response.read_body
  end
end
# End Send the request

puts 'Closing...'
