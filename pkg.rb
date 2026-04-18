#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "pathname"

options = {
  formula: "squigit-ocr.rb",
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby pkg.rb --version <v> --url <u> --sha256 <s> [--formula <file>]"

  opts.on("--formula FILE", "Formula file path (default: squigit-ocr.rb)") do |v|
    options[:formula] = v
  end

  opts.on("--version VERSION", "Formula version value") do |v|
    options[:version] = v.strip
  end

  opts.on("--url URL", "Formula URL value") do |v|
    options[:url] = v.strip
  end

  opts.on("--sha256 SHA", "Formula sha256 value") do |v|
    options[:sha256] = v.strip
  end

  opts.on("-h", "--help", "Show this help") do
    puts opts
    exit 0
  end
end

begin
  parser.parse!
rescue OptionParser::ParseError => e
  warn "Argument error: #{e.message}"
  warn parser
  exit 2
end

%i[version url sha256].each do |key|
  if options[key].nil? || options[key].empty?
    warn "Missing required option --#{key}"
    warn parser
    exit 2
  end
end

unless options[:sha256].match?(/\A\h{64}\z/)
  warn "Invalid sha256 value; expected 64 hex characters."
  exit 2
end

formula_path = Pathname.new(options[:formula]).expand_path
unless formula_path.exist?
  warn "Formula file not found: #{formula_path}"
  exit 1
end

content = formula_path.read

def replace_required_line(content, key, value)
  # Accept either quote style, optional trailing whitespace/comments, and CRLF line endings.
  pattern = /^(\s*#{Regexp.escape(key)}\s+)(["']).*?\2(\s*(?:#.*)?)$/
  updated = content.sub(pattern) { "#{Regexp.last_match(1)}\"#{value}\"#{Regexp.last_match(3)}" }
  if updated == content
    raise "Unable to find #{key} line in formula."
  end
  updated
end

begin
  updated = content.dup
  updated = replace_required_line(updated, "url", options[:url])
  updated = replace_required_line(updated, "sha256", options[:sha256])
  updated = replace_required_line(updated, "version", options[:version])
rescue StandardError => e
  warn "Failed to update formula: #{e.message}"
  exit 1
end

if updated == content
  puts "No formula changes needed: #{formula_path}"
  exit 0
end

formula_path.write(updated)
puts "Updated #{formula_path}"
puts "  version: #{options[:version]}"
puts "  url: #{options[:url]}"
puts "  sha256: #{options[:sha256]}"
