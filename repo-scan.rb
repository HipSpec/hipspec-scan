require 'json'
require 'git'
require 'net/http'

git_server_url = ENV['GITHUB_SERVER_URL'] || 'not_provided' # Example: https://github.com
git_repo = ENV['GITHUB_REPOSITORY'] || 'not_provided' # Example: octocat/Hello-World
git_sha = ENV['GITHUB_SHA'] || 'not_provided' # Example: ffac537e6cbbf934b08745a378932722df287a53
git_ref = ENV['GITHUB_REF'] || 'not_provided' # Example: refs/heads/feature-branch-1 or tag
git_actor = ENV['GITHUB_actor'] || 'not_provided' # Example: octocat

webhook_target = ENV['HIPSPEC_WEBHOOK']
uri = URI(webhook_target)

puts "GITHUB_SERVER_URL: #{git_server_url}"
puts "GITHUB_REPO: #{git_repo}"
puts "GITHUB_ACTOR: #{git_actor}"
puts "GITHUB_SHA: #{git_sha}"

g = Git.open('./')
data = g.grep('HIPSPEC-')

data = data.map { |k, v| { location: k, identifiers: v.to_a } }
data = data.to_json

puts 'Writing scan to output file: hipspec-data.json'
File.write('./hipspec-data.json', data)

if uri.nil?
  puts 'Please Configure webhook: https://docs.hipspec.com'
else
  puts 'Post To HipSpec Webhook:'
  req = Net::HTTP::Post.new(uri, {
                              'Content-Type': 'application/json'
                            })

  req.body = {
    "server_url": git_server_url,
    "repo": git_repo,
    "sha": git_sha,
    "git_ref": git_ref,
    "git_actor": git_actor,
    "scan_data": data
  }.to_json

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    response = http.request(req)
    puts response.read_body
  end
end
# End Send the request

puts 'Closing... Script, Returning to Pipeline'
