#!/usr/bin/env ruby
# Read-only route validator. Run after Reference Brief and before any Build Manifest.

require "yaml"

path = ARGV[0] || File.expand_path("../interfaces/coverage-report.example.yaml", __dir__)
report = YAML.load_file(path)
errors = []

route = report.dig("decision", "route")
artifact = report.dig("decision", "artifact")
missing = report.dig("coverage", "missing") || []
kinds = missing.map { |item| item["kind"] }.uniq

valid_routes = %w[cast mold_making owner_unblock content_replan]
errors << "UNKNOWN_ROUTE: #{route}" unless valid_routes.include?(route)

case route
when "cast"
  errors << "CAST_HAS_MISSING_ITEMS" unless missing.empty?
  errors << "CAST_ARTIFACT_INVALID: #{artifact}" unless artifact == "none"
when "mold_making"
  errors << "MOLD_GAP_REQUIRES_DESIGN_ASSET" unless kinds.include?("design_asset")
  errors << "MOLD_GAP_HAS_NON_DESIGN_ITEMS: #{kinds.join(',')}" unless (kinds - ["design_asset"]).empty?
  errors << "MOLD_GAP_ARTIFACT_INVALID: #{artifact}" unless artifact == "mold_gap"
when "owner_unblock"
  errors << "GAP_REPORT_REQUIRES_OWNER_ACCESS" unless kinds.include?("owner_access")
  errors << "GAP_REPORT_HAS_NON_ACCESS_ITEMS: #{kinds.join(',')}" unless (kinds - ["owner_access"]).empty?
  errors << "GAP_REPORT_ARTIFACT_INVALID: #{artifact}" unless artifact == "gap_report"
when "content_replan"
  errors << "CONTENT_REPLAN_REQUIRES_CAPACITY" unless kinds.include?("content_capacity")
  errors << "CONTENT_REPLAN_HAS_NON_CONTENT_ITEMS: #{kinds.join(',')}" unless (kinds - ["content_capacity"]).empty?
  errors << "CONTENT_REPLAN_ARTIFACT_INVALID: #{artifact}" unless artifact == "content_replan"
end

if errors.empty?
  puts "COVERAGE_ROUTE=pass report_id=#{report['report_id']} route=#{route}"
else
  warn errors.map { |error| "COVERAGE_ROUTE_BLOCK: #{error}" }.join("\n")
  exit 2
end
