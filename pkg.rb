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

def replace_required_line(content, pattern, replacement, label)
  updated = content.sub(pattern, replacement)
  if updated == content
    raise "Unable to find #{label} line in formula."
  end
  updated
end

begin
  updated = content.dup
  updated = replace_required_line(
    updated,
    /^(\s*url\s+)".*"$/,
    "\\1\"#{options[:url]}\"",
    "url"
  )
  updated = replace_required_line(
    updated,
    /^(\s*sha256\s+)".*"$/,
    "\\1\"#{options[:sha256]}\"",
    "sha256"
  )
  updated = replace_required_line(
    updated,
    /^(\s*version\s+)".*"$/,
    "\\1\"#{options[:version]}\"",
    "version"
  )
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
