#!/usr/bin/env ruby
# Read-only preflight. It must pass before any Production Figma mutation.

require "yaml"

profile_root = File.expand_path("../projects/aegis-x", __dir__)
manifest_path = ARGV[0] || File.join(profile_root, "interfaces/build-manifest.example.yaml")
registry_path = ARGV[1] || File.join(profile_root, "interfaces/component-registry.yaml")
policy_path = ARGV[2] || File.join(profile_root, "interfaces/binding-policy.yaml")

manifest = YAML.load_file(manifest_path)
registry = YAML.load_file(registry_path)
policy = YAML.load_file(policy_path)
errors = []

components = registry.fetch("components", []).to_h { |component| [component["registry_id"], component] }
template_ref = manifest.fetch("template", {})
template = components[template_ref["registry_id"]]

if template.nil?
  errors << "UNKNOWN_TEMPLATE: #{template_ref['registry_id']}"
else
  errors << "TEMPLATE_NOT_APPROVED: #{template['registry_id']} status=#{template['status']}" unless template["status"] == "Approved"
  registry_key = template.dig("figma", "component_key")
  errors << "TEMPLATE_KEY_MISSING: #{template['registry_id']}" if registry_key.to_s.empty?
  errors << "TEMPLATE_KEY_MISMATCH: manifest=#{template_ref['component_key']} registry=#{registry_key}" unless template_ref["component_key"] == registry_key
end

manifest.fetch("instances", []).each do |instance|
  component = components[instance["registry_id"]]
  if component.nil?
    errors << "UNKNOWN_INSTANCE: #{instance['registry_id']}"
  elsif component["status"] != "Approved"
    errors << "INSTANCE_NOT_APPROVED: #{instance['registry_id']} status=#{component['status']}"
  end
end

known_variables = registry.dig("foundations", "required_variable_names") || []
manifest_variables = manifest.dig("bindings", "variables") || []
manifest_variables.each do |name|
  errors << "UNKNOWN_VARIABLE: #{name}" unless known_variables.include?(name)
end

if template
  required_variables = template.dig("required_bindings", "variables") || []
  (required_variables - manifest_variables).each { |name| errors << "REQUIRED_VARIABLE_OMITTED: #{name}" }

  required_styles = %w[text_styles effect_styles paint_styles].flat_map { |key| template.dig("required_bindings", key) || [] }
  manifest_styles = manifest.dig("bindings", "styles") || []
  (required_styles - manifest_styles).each { |name| errors << "REQUIRED_STYLE_OMITTED: #{name}" }

  component_literals = template.fetch("allowed_literals", []).map { |item| [item["field"].to_s, item["value"].to_s] }
  page_container_allowed = policy.dig("production_exceptions", "page_container", "allowed_when")
  manifest.fetch("allowed_literals", []).each do |literal|
    signature = [literal["field"].to_s, literal["value"].to_s]
    next if component_literals.include?(signature)
    next if literal["field"] == "page_container" && page_container_allowed
    errors << "UNDECLARED_LITERAL: #{signature.join('=')}"
  end
end

manifest.fetch("content_budget", {}).each do |slot, budget|
  limit = budget["limit_zh"]
  actual = budget["actual_zh"]
  errors << "CONTENT_BUDGET_EXCEEDED: #{slot} actual=#{actual} limit=#{limit}" if limit && actual && actual > limit
end

if manifest.dig("gap_policy", "allow_approximate_fallback") != false
  errors << "FALLBACK_POLICY_INVALID: allow_approximate_fallback must be false"
end

if errors.empty?
  puts "MANIFEST_PREFLIGHT=pass build_id=#{manifest['build_id']}"
else
  warn errors.map { |error| "MANIFEST_PREFLIGHT_BLOCK: #{error}" }.join("\n")
  exit 2
end
