// Run through use_figma. Fill the IDs and Manifest-derived allow lists first.
const TARGET_NODE_ID = "REPLACE_WITH_TARGET_NODE_ID";
const THEME_COMPARE_NODE_ID = null; // Optional Dark/Light counterpart.
const ALLOWED_LITERAL_NODE_NAMES = ["Layout / Pilot Host"];
const ALLOWED_ABSOLUTE_NODE_NAMES = [];
const RECIPE_NAME_PATTERN = /^(Material|Template|Recipe)\s*\//i;

const target = await figma.getNodeByIdAsync(TARGET_NODE_ID);
if (!target || !("findAll" in target)) return { error: "Target is missing or not traversable" };

const issues = [];
const all = [target, ...target.findAll(() => true)];

const hasBinding = (node, property) => {
  if (!node.boundVariables) return false;
  if (node.boundVariables[property]) return true;
  if (property === "strokeWeight") {
    return ["strokeTopWeight", "strokeRightWeight", "strokeBottomWeight", "strokeLeftWeight"]
      .every(field => node.boundVariables[field]);
  }
  return false;
};
const paintHasColorBinding = paints => Array.isArray(paints) && paints.some(paint => paint && paint.boundVariables && paint.boundVariables.color);
const issue = (node, code, property, value, severity = "error") => issues.push({ severity, code, nodeId: node.id, nodeName: node.name, property, value });

for (const node of all) {
  const allowedLiteral = ALLOWED_LITERAL_NODE_NAMES.includes(node.name);

  if (node.type === "FRAME" && RECIPE_NAME_PATTERN.test(node.name) && !allowedLiteral) {
    issue(node, "RECIPE_LIKE_FRAME", "type", node.type);
  }

  if ("fills" in node && Array.isArray(node.fills)) {
    const solidPaints = node.fills.filter(paint => paint.type === "SOLID" && paint.visible !== false);
    if (solidPaints.length && !hasBinding(node, "fills") && !paintHasColorBinding(node.fills) && !allowedLiteral) {
      issue(node, "UNBOUND_FILL", "fills", solidPaints.map(paint => paint.color));
    }
  }

  if ("strokes" in node && Array.isArray(node.strokes)) {
    const solidStrokes = node.strokes.filter(paint => paint.type === "SOLID" && paint.visible !== false);
    if (solidStrokes.length && !hasBinding(node, "strokes") && !paintHasColorBinding(node.strokes) && !allowedLiteral) {
      issue(node, "UNBOUND_STROKE", "strokes", solidStrokes.map(paint => paint.color));
    }
  }

  const numericFields = ["opacity", "strokeWeight", "cornerRadius", "paddingTop", "paddingRight", "paddingBottom", "paddingLeft", "itemSpacing"];
  for (const field of numericFields) {
    if (field in node && typeof node[field] === "number" && node[field] !== 0 && !hasBinding(node, field) && !allowedLiteral) {
      issue(node, "UNBOUND_NUMBER", field, node[field]);
    }
  }

  if (node.type === "TEXT" && (!node.textStyleId || node.textStyleId === "" || node.textStyleId === figma.mixed)) {
    issue(node, "MISSING_TEXT_STYLE", "textStyleId", String(node.textStyleId));
  }

  if ("layoutPositioning" in node && node.layoutPositioning === "ABSOLUTE" && !ALLOWED_ABSOLUTE_NODE_NAMES.includes(node.name)) {
    issue(node, "UNDECLARED_ABSOLUTE", "layoutPositioning", "ABSOLUTE");
  }
}

const buildGeometryMap = root => {
  const map = new Map();
  const walk = (node, path) => {
    const next = `${path}/${node.name}`;
    if ("width" in node) map.set(next, { nodeId: node.id, x: node.x, y: node.y, width: node.width, height: node.height });
    if ("children" in node) for (const child of node.children) walk(child, next);
  };
  walk(root, "");
  return map;
};

if (THEME_COMPARE_NODE_ID) {
  const compare = await figma.getNodeByIdAsync(THEME_COMPARE_NODE_ID);
  if (compare) {
    const a = buildGeometryMap(target);
    const b = buildGeometryMap(compare);
    for (const [path, geometry] of a) {
      const counterpart = b.get(path);
      if (!counterpart) {
        issues.push({ severity: "error", code: "THEME_NODE_MISSING", path, nodeId: geometry.nodeId });
        continue;
      }
      for (const field of ["x", "y", "width", "height"]) {
        if (Math.abs(geometry[field] - counterpart[field]) > 0.5) {
          issues.push({ severity: "error", code: "THEME_GEOMETRY_DELTA", path, field, dark: geometry[field], light: counterpart[field] });
        }
      }
    }
  }
}

return {
  target: { id: target.id, name: target.name },
  summary: {
    traversedNodes: all.length,
    instances: all.filter(node => node.type === "INSTANCE").length,
    issues: issues.length,
    errors: issues.filter(item => item.severity === "error").length
  },
  issues
};
