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
# ─────────────────────────────────────────────────────────

IMPLEMENTATIONS = %i[
  fernando_melo_cunha_reverse_str
  berfy_kunsangabo_web_reverse_str
  serhii_s_b6b528a1_reverse_str
  jess_alejo_prepend_reverse_str
  jess_alejo_reduce_reverse_str
  shilpa_parate_084a08138_reverse_str
].freeze

STRINGS = {
  short:  'a' * 10,
  medium: 'a' * 1_000,
  long:   'a' * 1_000_000
}.freeze

results = {}

# ──────────────── one pass with rescue ────────────────
STRINGS.each do |size, str|
  results[size] = IMPLEMENTATIONS.map do |name|
    fn  = method(name)
    res = begin
            Benchmark.measure { fn.call(str) }
          rescue SystemStackError, StandardError => e
            e
          end
    [name, res]
  end
end
# ────────────────────────────────────────────────────────

# ──────────────── output by speed ────────────────
results.each do |size, data|
  puts "\n#{size.capitalize} (#{STRINGS[size].bytesize} bytes)"
  data
    .sort_by { |_, r| r.is_a?(Benchmark::Tms) ? r.real : Float::INFINITY }
    .each do |name, r|
      if r.is_a?(Benchmark::Tms)
        puts "%-35s %.6f s" % [name, r.real]
      else
        puts "%-35s %s"     % [name, r.message]
      end
    end
end
# ────────────────────────────────────────────────────────
