lib_folder = File.expand_path('../lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_folder) unless $LOAD_PATH.include?(lib_folder)

require 'generate_explorer'

generator = GenerateExplorer.new
counts = generator.perform

puts 'Staging Mock Explorer generated → mocks/explorer.html'
puts "  folders processed : #{generator.folders_processed}"
puts "  endpoints         : #{counts[:endpoints]}"
puts "  cases             : #{counts[:cases]}"
puts "  cases with cURL   : #{counts[:curls]}"
puts "  skipped files     : #{counts[:skipped]}"

unless generator.skipped.empty?
  puts '  skipped detail:'
  generator.skipped.each { |s| puts "    - #{s[:file]} (#{s[:reason]})" }
end
