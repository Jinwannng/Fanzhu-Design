// Run through use_figma. Replace TARGET_PAGE_ID with one real page id.
const TARGET_PAGE_ID = "REPLACE_WITH_PAGE_ID";

const pages = figma.root.children.map(page => ({ id: page.id, name: page.name }));
const page = await figma.getNodeByIdAsync(TARGET_PAGE_ID);
if (!page || page.type !== "PAGE") return { error: "TARGET_PAGE_ID is not a page", pages };

await figma.setCurrentPageAsync(page);
figma.skipInvisibleInstanceChildren = true;

const collections = await figma.variables.getLocalVariableCollectionsAsync();
const variables = await figma.variables.getLocalVariablesAsync();
const textStyles = await figma.getLocalTextStylesAsync();
const effectStyles = await figma.getLocalEffectStylesAsync();
const paintStyles = await figma.getLocalPaintStylesAsync();
const components = page.findAll(node => node.type === "COMPONENT" || node.type === "COMPONENT_SET");

const duplicateNames = items => {
  const counts = {};
  for (const item of items) counts[item.name] = (counts[item.name] || 0) + 1;
  return Object.entries(counts).filter(([, count]) => count > 1).map(([name, count]) => ({ name, count }));
};

return {
  pages,
  targetPage: {
    id: page.id,
    name: page.name,
    topLevel: page.children.map(node => ({ id: node.id, name: node.name, type: node.type, width: node.width, height: node.height }))
  },
  collections: collections.map(collection => ({
    id: collection.id,
    name: collection.name,
    modes: collection.modes,
    defaultModeId: collection.defaultModeId,
    variableCount: collection.variableIds.length
  })),
  variables: variables.map(variable => ({
    id: variable.id,
    key: variable.key,
    name: variable.name,
    collectionId: variable.variableCollectionId,
    resolvedType: variable.resolvedType,
    scopes: variable.scopes,
    codeSyntax: variable.codeSyntax
  })),
  components: components.map(component => ({
    id: component.id,
    key: component.key,
    name: component.name,
    type: component.type,
    description: component.description,
    properties: component.componentPropertyDefinitions || {}
  })),
  styles: {
    text: textStyles.map(style => ({ id: style.id, key: style.key, name: style.name })),
    effect: effectStyles.map(style => ({ id: style.id, key: style.key, name: style.name })),
    paint: paintStyles.map(style => ({ id: style.id, key: style.key, name: style.name }))
  },
  conflicts: {
    variables: duplicateNames(variables),
    components: duplicateNames(components),
    textStyles: duplicateNames(textStyles),
    effectStyles: duplicateNames(effectStyles),
    paintStyles: duplicateNames(paintStyles)
  },
  remoteInventoryRequired: true,
  note: "Run get_libraries and remote design-system search separately; local Plugin API output is not proof that Library assets do not exist."
};
