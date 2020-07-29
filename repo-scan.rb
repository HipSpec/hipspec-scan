require 'json'
require 'git'

puts "GITHUB_REPO: #{env.GITHUB_REPOSITORY}"
puts "GITHUB_SHA: #{env.GITHUB_SHA}"

g = Git.open('../')
data = g.grep('HIPSPEC').to_json

puts 'env'
puts 'Writing to output file: hipspec-data.json'
File.write('./hipspec-data.json', data)
puts 'File Created'