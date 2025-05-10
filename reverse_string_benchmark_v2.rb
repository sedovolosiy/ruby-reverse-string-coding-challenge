#!/usr/bin/env ruby
#
# Quick benchmark for Ruby 3.4.2
# Run with:
#   ruby --yjit reverse_string_benchmark_v3.rb
# or
#   ruby --rjit reverse_string_benchmark_v3.rb

require 'benchmark'

# ──────────────── original implementations ────────────────
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
  # output = ''
  index  = string.length - 1
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
  reverse = ''
  string.chars.each { |char| reverse = char + reverse }
  reverse
end

def serhii_s_b6b528a1_while_reverse_str(string)
 len    = string.bytesize
  # 2. Сразу выделяем буфер нужного размера (нулевая строка в бинарном виде)
  output = "\0".b * len
  # 3. Два счётчика: i идёт с конца input, j — с начала output
  i = len - 1
  j = 0

  # 4. Цикл без вызовов Ruby-методов внутри:
  while i >= 0
    # getbyte/setbyte — чистые C-методы, они не аллоцируют и не конвертируют
    output.setbyte(j, string.getbyte(i))
    i -= 1
    j += 1
  end

  # 5. Восстанавливаем кодировку исходной строки
  output.force_encoding(string.encoding)
end

def serhii_s_b6b528a1_dowto_reverse_srt(string)
  len    = string.bytesize
  # 1) создаём строку ровно нужной длины, заполняя нулями
  output = "\0".b * len
  # 2) C-цикл Fixnum#downto для перебора индексов
  (len - 1).downto(0) do |i|
    # 3) getbyte/setbyte — чистый C, без аллокаций
    output.setbyte(len - 1 - i, string.getbyte(i))
  end
  # 4) возвращаем ту же кодировку, что у исходной
  output.force_encoding(string.encoding)
  # 5. Restore the encoding of the original string
end


# ─────────────────────────────────────────────────────────

IMPLEMENTATIONS = %i[
  fernando_melo_cunha_reverse_str
  serhii_s_b6b528a1_reverse_str
  serhii_s_b6b528a1_dowto_reverse_srt
  serhii_s_b6b528a1_while_reverse_str
].freeze

STRINGS = {
  short:  'a' * 10,
  medium: 'a' * 1_000,
  long:   'a' * 1_000_000,
  # Adding a test case with string.dup.clear to preserve encoding
  encoding_test: "Hello 🌍".encode("UTF-8"),
  windows_1251_test: "Hello world".encode("Windows-1251") # New test case
}.freeze

results = {}

# ──────────────── one pass with rescue ────────────────
STRINGS.each do |size, str|
  results[size] = IMPLEMENTATIONS.map do |name|
    fn  = method(name)
    res = begin
            # Store both benchmark and the actual reversed string
            reversed_str_result = nil
            benchmark_result = Benchmark.measure { reversed_str_result = fn.call(str) }
            { benchmark: benchmark_result, output: reversed_str_result }
          rescue SystemStackError, StandardError => e
            { error: e }
          end
    [name, res]
  end
end
# ────────────────────────────────────────────────────────

# ──────────────── output by speed ────────────────
results.each do |size, data|
  puts "\n#{size.capitalize} (#{STRINGS[size].bytesize} bytes, encoding: #{STRINGS[size].encoding})" # Added encoding info
  data
    .sort_by do |_, r_data|
      if r_data.key?(:benchmark)
        r_data[:benchmark].real
      else
        Float::INFINITY
      end
    end
    .each do |name, r_data|
      if r_data.key?(:benchmark)
        puts "%-35s %.6f s" % [name, r_data[:benchmark].real]
        if [:encoding_test, :windows_1251_test].include?(size) # Check for both encoding tests
          # Ensure the output string is also in UTF-8 for printing
          puts "    Input Encoding: #{STRINGS[size].encoding}, Output Encoding: #{r_data[:output].encoding}"
          output_str = r_data[:output].encode("UTF-8", invalid: :replace, undef: :replace, replace: '?')
          puts "    Output (as UTF-8): #{output_str}"
        end
      else
        puts "%-35s %s"     % [name, r_data[:error].message]
      end
    end
end
# ────────────────────────────────────────────────────────
