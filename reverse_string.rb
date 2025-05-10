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
    [:jess_alejo_reduce_reverse_str, method(:jess_alejo_reduce_reverse_str)]
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

Benchmark.bm do |x|
  results[:short] = [
    pretest_errors[:short][:fernando_melo_cunha_reverse_str] ? nil : (begin; x.report('fernando_melo_cunha_reverse_str (short)') { fernando_melo_cunha_reverse_str(short_string) }; rescue; nil; end),
    pretest_errors[:short][:berfy_kunsangabo_web_reverse_str] ? nil : (begin; x.report('berfy_kunsangabo_web_reverse_str (short)') { berfy_kunsangabo_web_reverse_str(short_string) }; rescue; nil; end),
    pretest_errors[:short][:serhii_s_b6b528a1_reverse_str] ? nil : (begin; x.report('serhii_s_b6b528a1_reverse_str (short)') { serhii_s_b6b528a1_reverse_str(short_string) }; rescue; nil; end),
    pretest_errors[:short][:jess_alejo_prepend_reverse_str] ? nil : (begin; x.report('jess_alejo_prepend_reverse_str (short)') { jess_alejo_prepend_reverse_str(short_string) }; rescue; nil; end),
    pretest_errors[:short][:jess_alejo_reduce_reverse_str] ? nil : (begin; x.report('jess_alejo_reduce_reverse_str (short)') { jess_alejo_reduce_reverse_str(short_string) }; rescue; nil; end)
  ].compact.sort_by(&:real)

  results[:medium] = [
    pretest_errors[:medium][:fernando_melo_cunha_reverse_str] ? nil : (begin; x.report('fernando_melo_cunha_reverse_str (medium)') { fernando_melo_cunha_reverse_str(medium_string) }; rescue; nil; end),
    pretest_errors[:medium][:berfy_kunsangabo_web_reverse_str] ? nil : (begin; x.report('berfy_kunsangabo_web_reverse_str (medium)') { berfy_kunsangabo_web_reverse_str(medium_string) }; rescue; nil; end),
    pretest_errors[:medium][:serhii_s_b6b528a1_reverse_str] ? nil : (begin; x.report('serhii_s_b6b528a1_reverse_str (medium)') { serhii_s_b6b528a1_reverse_str(medium_string) }; rescue; nil; end),
    pretest_errors[:medium][:jess_alejo_prepend_reverse_str] ? nil : (begin; x.report('jess_alejo_prepend_reverse_str (medium)') { jess_alejo_prepend_reverse_str(medium_string) }; rescue; nil; end),
    pretest_errors[:medium][:jess_alejo_reduce_reverse_str] ? nil : (begin; x.report('jess_alejo_reduce_reverse_str (medium)') { jess_alejo_reduce_reverse_str(medium_string) }; rescue; nil; end)
  ].compact.sort_by(&:real)

  results[:long] = [
    pretest_errors[:long][:fernando_melo_cunha_reverse_str] ? nil : (begin; x.report('fernando_melo_cunha_reverse_str (long)') { fernando_melo_cunha_reverse_str(long_string) }; rescue; nil; end),
    pretest_errors[:long][:berfy_kunsangabo_web_reverse_str] ? nil : (begin; x.report('berfy_kunsangabo_web_reverse_str (long)') { berfy_kunsangabo_web_reverse_str(long_string) }; rescue; nil; end),
    pretest_errors[:long][:serhii_s_b6b528a1_reverse_str] ? nil : (begin; x.report('serhii_s_b6b528a1_reverse_str (long)') { serhii_s_b6b528a1_reverse_str(long_string) }; rescue; nil; end),
    pretest_errors[:long][:jess_alejo_prepend_reverse_str] ? nil : (begin; x.report('jess_alejo_prepend_reverse_str (long)') { jess_alejo_prepend_reverse_str(long_string) }; rescue; nil; end),
    pretest_errors[:long][:jess_alejo_reduce_reverse_str] ? nil : (begin; x.report('jess_alejo_reduce_reverse_str (long)') { jess_alejo_reduce_reverse_str(long_string) }; rescue; nil; end)
  ].compact.sort_by(&:real)
end

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