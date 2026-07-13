#!/usr/bin/env ruby
# Deterministic guard against README section drift or stale-version merges.

path = ARGV.find { |arg| !arg.start_with?("--") } || File.expand_path("../README.md", __dir__)
self_test = ARGV.include?("--self-test")

EXPECTED = [
  "1. 为什么需要范铸",
  "2. 范铸能做什么",
  "3. 核心模型",
  "4. 从灵感到 Figma 的新工作流",
  "5. 三道门与生命周期",
  "6. 工具与机器接口",
  "7. Project Profile",
  "8. 运行环境",
  "9. 人如何使用",
  "10. AI 如何开始",
  "11. AEGIS X 当前状态",
  "12. 下一步",
  "13. 非目标"
].freeze

ANCHORS = {
  "1. 为什么需要范铸" => ["先制范，再浇铸", "第二次以后快速"],
  "3. 核心模型" => ["循环 A · 制范", "循环 B · 浇铸", "灵感覆盖路由"],
  "4. 从灵感到 Figma 的新工作流" => ["Approved 范是否覆盖", "Mold Gap", "ChangesRequested"],
  "5. 三道门与生命周期" => ["Reuse Gate", "Binding Gate", "Visual Gate", "InReview"],
  "6. 工具与机器接口" => ["fanzhu-library", "fanzhu-production", "Build Manifest"],
  "7. Project Profile" => ["projects/<project-id>/", "AEGIS X"],
  "10. AI 如何开始" => ["check-readme-structure.rb", "validate-manifest.rb"],
  "11. AEGIS X 当前状态" => ["InReview", "Library", "Cover、Compare、Data"],
  "12. 下一步" => ["P0", "P1", "P2", "P3"]
}.freeze

def validate(text)
  errors = []
  headings = text.scan(/^## (.+)$/).flatten
  errors << "H2 order mismatch: #{headings.inspect}" unless headings == EXPECTED
  counts = headings.each_with_object(Hash.new(0)) { |name, result| result[name] += 1 }
  duplicates = counts.select { |_name, count| count > 1 }.keys
  errors << "duplicate H2 headings: #{duplicates.join(', ')}" unless duplicates.empty?

  sections = {}
  text.split(/^## /).drop(1).each do |chunk|
    name, body = chunk.split("\n", 2)
    sections[name.strip] = body.to_s
  end
  ANCHORS.each do |heading, anchors|
    anchors.each do |anchor|
      errors << "#{heading} is missing anchor: #{anchor}" unless sections.fetch(heading, "").include?(anchor)
    end
  end

  marker = "范铸严格区分两个循环："
  if (index = text.index(marker))
    following = text[(index + marker.length)..].lines.find { |line| !line.strip.empty? }.to_s.strip
    errors << "colon/list relationship is broken after '#{marker}'" unless following.match?(/^1[.)、]/)
  end
  errors
end

text = File.read(path)
errors = validate(text)

if self_test
  corrupted = text.sub("## 1. 为什么需要范铸", "## 5. 三道门与生命周期")
  detected = validate(corrupted)
  abort("SELF_TEST_FAILED: checker did not catch a shifted heading") if detected.empty?
  puts "SELF_TEST_RED_CAPABLE=#{detected.first}"
end

if errors.empty?
  puts "README_STRUCTURE=ok file=#{path}"
else
  warn errors.map { |error| "README_STRUCTURE_ERROR: #{error}" }.join("\n")
  exit 1
end
