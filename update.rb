#!/usr/bin/env ruby
# frozen_string_literal: true

# Bump a formula (or all formulas) to the latest GitHub release of its
# upstream project, refreshing version + sha256 for every asset URL.
#
# Usage:
#   script/update-formula <name> [version]   # bump one formula
#   script/update-formula --all              # bump every formula in Formula/
#
# The upstream repo is inferred from the first GitHub release URL in the
# formula. Asset filenames are derived by substituting the version into the
# existing URL pattern, so renaming an asset across releases will require a
# manual edit.
#
# Honors $GITHUB_TOKEN to avoid the 60 req/hour unauthenticated rate limit.

require "digest"
require "json"
require "net/http"
require "uri"

FORMULA_DIR = File.expand_path("Formula", __dir__).freeze

def die(msg)
  warn "error: #{msg}"
  exit 1
end

def http_get(uri, headers = {}, depth = 0)
  die "too many redirects" if depth > 5
  uri = URI(uri) unless uri.is_a?(URI)
  req = Net::HTTP::Get.new(uri)
  headers.each { |k, v| req[k] = v }
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |h|
    h.request(req)
  end
  case res
  when Net::HTTPRedirection then http_get(res["location"], headers, depth + 1)
  when Net::HTTPSuccess     then res
  else die "GET #{uri} → #{res.code} #{res.message}"
  end
end

def github_latest_tag(repo)
  headers = {
    "Accept"               => "application/vnd.github+json",
    "X-GitHub-Api-Version" => "2022-11-28",
  }
  headers["Authorization"] = "Bearer #{ENV["GITHUB_TOKEN"]}" if ENV["GITHUB_TOKEN"]
  body = http_get("https://api.github.com/repos/#{repo}/releases/latest", headers).body
  JSON.parse(body).fetch("tag_name")
end

def fetch_sha256(url)
  Digest::SHA256.hexdigest(http_get(url).body)
end

def update_formula(path, target_version: nil)
  name = File.basename(path, ".rb")
  formula = File.read(path)

  repo = formula[%r{https://github\.com/([^/]+/[^/]+)/releases/download/}, 1]
  die "#{name}: no github release URLs found" unless repo

  old_version = formula[/^\s*version\s+"([^"]+)"/, 1]
  die "#{name}: no `version` line found" unless old_version

  new_version = target_version || github_latest_tag(repo).sub(/^v/, "")

  if old_version == new_version
    puts "#{name}: already at #{new_version}"
    return
  end

  puts "#{name}: #{old_version} → #{new_version}"

  updated = formula.sub(/(^\s*version\s+")[^"]+(")/, "\\1#{new_version}\\2")
  updated = updated.gsub(/url\s+"([^"]+)"(\s+)sha256\s+"[0-9a-f]{64}"/) do
    old_url = Regexp.last_match(1)
    spacing = Regexp.last_match(2)
    new_url = old_url
              .gsub("v#{old_version}", "v#{new_version}")
              .gsub("/#{old_version}/", "/#{new_version}/")
    print "  #{File.basename(new_url)} ... "
    sha = fetch_sha256(new_url)
    puts sha
    %Q(url "#{new_url}"#{spacing}sha256 "#{sha}")
  end

  File.write(path, updated)
end

case ARGV[0]
when nil
  die "usage: #{File.basename($PROGRAM_NAME)} <name> [version] | --all"
when "--all"
  Dir[File.join(FORMULA_DIR, "*.rb")].each { |p| update_formula(p) }
else
  path = File.join(FORMULA_DIR, "#{ARGV[0]}.rb")
  die "no such formula: #{path}" unless File.exist?(path)
  update_formula(path, target_version: ARGV[1])
end
