#!/usr/bin/env ruby
# Ensure a human review produces evidence-backed, directed findings rather than vague critique.

require "yaml"

path = ARGV[0] || File.expand_path("../interfaces/review-record.example.yaml", __dir__)
review = YAML.load_file(path)
errors = []

def present?(value)
  return !value.strip.empty? if value.is_a?(String)
  return !value.empty? if value.respond_to?(:empty?)
  !value.nil?
end

%w[review_id target page_type verdict evidence decision].each do |field|
  errors << "MISSING_FIELD: #{field}" unless present?(review[field])
end

valid_verdicts = %w[Approved ChangesRequested]
errors << "UNKNOWN_VERDICT: #{review['verdict']}" unless valid_verdicts.include?(review["verdict"])

findings = review["findings"] || []
if review["verdict"] == "ChangesRequested" && findings.empty?
  errors << "CHANGES_REQUESTED_WITHOUT_FINDINGS"
end

required_finding_fields = %w[dimension summary evidence blocking owner_interface return_step required_change]
findings.each_with_index do |finding, index|
  required_finding_fields.each do |field|
    value = finding[field]
    valid = field == "blocking" ? [true, false].include?(value) : present?(value)
    errors << "FINDING_#{index}_MISSING: #{field}" unless valid
  end
end

if review["verdict"] == "Approved" && findings.any? { |finding| finding["blocking"] == true }
  errors << "APPROVED_WITH_BLOCKING_FINDING"
end

if errors.empty?
  puts "REVIEW_RECORD=pass review_id=#{review['review_id']} verdict=#{review['verdict']} findings=#{findings.length}"
else
  warn errors.map { |error| "REVIEW_RECORD_BLOCK: #{error}" }.join("\n")
  exit 2
end
