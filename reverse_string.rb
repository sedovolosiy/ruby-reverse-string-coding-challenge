def fernando_melo_cunha_reverse_str(string)
  reversed_str = ''
  (1..string.length).each { |c| reversed_str << string[string.length - c] }
  reversed_str
end

def berfy_kunsangabo_web_reverse_str(string)
  return string if string.length <= 1
  string[-1] + berfy_kunsangabo_web_reverse_str(string[0...-1])
end

def serhii_s_b6b528a1_reverse_str(string)
  output = string.dup.clear
  index = string.length - 1
  while index >= 0
    output << string[index]
    index -= 1
  end
  output
end

def jess_alejo_prepend_reverse_str(string)
  reversed_string = ''
  string.each_char { |char| reversed_string.prepend(char) }
  reversed_string
end

def jess_alejo_reduce_reverse_str(string)
  string.each_char.reduce { |m, i| i + m }
end

def shilpa_parate_084a08138_reverse_str(string)
  reverse = ""
  string.chars.each do |char|
    reverse = char + reverse
  end
  reverse
end

require 'benchmark'

short_string = 'a' * 10
medium_string = 'a' * 1000
long_string = 'a' * 1_000_000

results = {}
pretest_errors = {
  short: {},
  medium: {},
  long: {}
}

# Check for execution errors for each method and string size
[:short, :medium, :long].each do |size|
  str = case size
        when :short then short_string
        when :medium then medium_string
        when :long then long_string
        end
  [
    [:fernando_melo_cunha_reverse_str, method(:fernando_melo_cunha_reverse_str)],
    [:berfy_kunsangabo_web_reverse_str, method(:berfy_kunsangabo_web_reverse_str)],
    [:serhii_s_b6b528a1_reverse_str, method(:serhii_s_b6b528a1_reverse_str)],
    [:jess_alejo_prepend_reverse_str, method(:jess_alejo_prepend_reverse_str)],
    [:jess_alejo_reduce_reverse_str, method(:jess_alejo_reduce_reverse_str)],
    [:shilpa_parate_084a08138_reverse_str, method(:shilpa_parate_084a08138_reverse_str)]
  ].each do |name, func|
    begin
      func.call(str)
    rescue SystemStackError
      pretest_errors[size][name] = 'Error: Stack level too deep'
    rescue Exception => e
      pretest_errors[size][name] = "Error: #{e.class}: #{e.message}"
    end
  end
end

threads = []
[:short, :medium, :long].each do |size|
  threads << Thread.new do
    str = case size
          when :short then short_string
          when :medium then medium_string
          when :long then long_string
          end
    Benchmark.bm do |x|
      results[size] = [
        pretest_errors[size][:fernando_melo_cunha_reverse_str] ? nil : (begin; x.report("fernando_melo_cunha_reverse_str (#{size})") { fernando_melo_cunha_reverse_str(str) }; rescue; nil; end),
        pretest_errors[size][:berfy_kunsangabo_web_reverse_str] ? nil : (begin; x.report("berfy_kunsangabo_web_reverse_str (#{size})") { berfy_kunsangabo_web_reverse_str(str) }; rescue; nil; end),
        pretest_errors[size][:serhii_s_b6b528a1_reverse_str] ? nil : (begin; x.report("serhii_s_b6b528a1_reverse_str (#{size})") { serhii_s_b6b528a1_reverse_str(str) }; rescue; nil; end),
        pretest_errors[size][:jess_alejo_prepend_reverse_str] ? nil : (begin; x.report("jess_alejo_prepend_reverse_str (#{size})") { jess_alejo_prepend_reverse_str(str) }; rescue; nil; end),
        pretest_errors[size][:jess_alejo_reduce_reverse_str] ? nil : (begin; x.report("jess_alejo_reduce_reverse_str (#{size})") { jess_alejo_reduce_reverse_str(str) }; rescue; nil; end),
        pretest_errors[size][:shilpa_parate_084a08138_reverse_str] ? nil : (begin; x.report("shilpa_parate_084a08138_reverse_str (#{size})") { shilpa_parate_084a08138_reverse_str(str) }; rescue; nil; end)
      ].compact.sort_by(&:real)
    end
  end
end
threads.each(&:join)

puts "\nSorted Results by Speed:"
results.each do |group, benchmarks|
  puts "\n#{group.capitalize} Strings:"
  benchmarks.each do |b|
    if b.label.include?("Error:")
      puts "#{b.label.strip}"
    else
      puts "#{b.label.strip}: %.6f seconds" % b.real
    end
  end
end