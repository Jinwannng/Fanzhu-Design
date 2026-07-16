#!/usr/bin/env ruby
# Structural validation for a Fanzhu Reference Brief. Production also requires Accepted status.

require "yaml"

path = ARGV.find { |arg| !arg.start_with?("--") } || File.expand_path("../interfaces/reference-brief.example.yaml", __dir__)
require_accepted = ARGV.include?("--require-accepted")
brief = YAML.load_file(path)
errors = []

def present?(value)
  return !value.strip.empty? if value.is_a?(String)
  return !value.empty? if value.respond_to?(:empty?)
  !value.nil?
end

required = {
  "brief_id" => brief["brief_id"],
  "status" => brief["status"],
  "intent.subject" => brief.dig("intent", "subject"),
  "intent.audience" => brief.dig("intent", "audience"),
  "intent.output" => brief.dig("intent", "output"),
  "intent.single_job" => brief.dig("intent", "single_job"),
  "intent.content_thesis" => brief.dig("intent", "content_thesis"),
  "intent.facts_to_preserve" => brief.dig("intent", "facts_to_preserve"),
  "information_architecture.primary_relationship" => brief.dig("information_architecture", "primary_relationship"),
  "information_architecture.hierarchy" => brief.dig("information_architecture", "hierarchy"),
  "information_architecture.page_types" => brief.dig("information_architecture", "page_types"),
  "design_direction.visual_thesis" => brief.dig("design_direction", "visual_thesis"),
  "design_direction.palette_roles" => brief.dig("design_direction", "palette_roles"),
  "design_direction.type_roles" => brief.dig("design_direction", "type_roles"),
  "design_direction.signature" => brief.dig("design_direction", "signature"),
  "design_direction.restraint" => brief.dig("design_direction", "restraint"),
  "design_direction.theme_behavior" => brief.dig("design_direction", "theme_behavior"),
  "handoff.visual_grammar" => brief.dig("handoff", "visual_grammar"),
  "handoff.layout_grammar" => brief.dig("handoff", "layout_grammar"),
  "handoff.component_semantics" => brief.dig("handoff", "component_semantics"),
  "handoff.content_rules" => brief.dig("handoff", "content_rules"),
  "approval.human_owner" => brief.dig("approval", "human_owner")
}

required.each { |field, value| errors << "MISSING_FIELD: #{field}" unless present?(value) }

valid_statuses = %w[Draft Accepted ChangesRequested]
errors << "UNKNOWN_STATUS: #{brief['status']}" unless valid_statuses.include?(brief["status"])

open_decisions = brief.dig("handoff", "open_decisions") || []
if brief["status"] == "Accepted" && !open_decisions.empty?
  errors << "ACCEPTED_BRIEF_HAS_OPEN_DECISIONS"
end

if brief["status"] == "Accepted" && !present?(brief.dig("approval", "accepted_at"))
  errors << "ACCEPTED_BRIEF_MISSING_ACCEPTED_AT"
end

if require_accepted && brief["status"] != "Accepted"
  errors << "REFERENCE_BRIEF_NOT_ACCEPTED: status=#{brief['status']}"
end

if errors.empty?
  readiness = brief["status"] == "Accepted" ? "accepted" : "ready_for_review"
  puts "REFERENCE_BRIEF=pass brief_id=#{brief['brief_id']} readiness=#{readiness}"
else
  warn errors.map { |error| "REFERENCE_BRIEF_BLOCK: #{error}" }.join("\n")
  exit 2
end
