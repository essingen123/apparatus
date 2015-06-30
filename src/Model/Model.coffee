_ = require "underscore"

Node = require "./Node"
Link = require "./Link"
Attribute = require "./Attribute"
Element = require "./Element"

module.exports = Model = {}

Model.Node = Node
Model.Link = Link
Model.Attribute = Attribute
Model.Element = Element


createAttribute = (label, name, exprString) ->
  attribute = Model.Attribute.createVariant
    label
    name
  attribute.setExpression(exprString)
  return attribute

Model.Variable = Model.Attribute.createVariant()


# =============================================================================
# Components
# =============================================================================

Model.Component = Node.createVariant
  getAttributesByName: ->
    attributes = @childrenOfType(Model.Attribute)
    return _.indexBy attributes, "name"


Model.Transform = Model.Component.createVariant
  label: "Transform"
  getMatrix: ->
    v = @getAttributesValuesByName()
    return Matrix.naturalConstruct(v.x, v.y, v.sx, v.sy, v.rotate)

Model.Transform.addChildren [
  createAttribute("X", "x", "0.00")
  createAttribute("Y", "y", "0.00")
  createAttribute("Scale X", "sx", "1.00")
  createAttribute("Scale Y", "sy", "1.00")
  createAttribute("Rotate", "rotate", "0.00")
]


Model.Fill = Model.Component.createVariant
  label: "Fill"

Model.Fill.addChildren [
  createAttribute("Fill Color", "color", "rgba(0.93, 0.93, 0.93, 1.00)")
]


Model.Stroke = Model.Component.createVariant
  label: "Stroke"

Model.Stroke.addChildren [
  createAttribute("Stroke Color", "color", "rgba(0.60, 0.60, 0.60, 1.00)")
  createAttribute("Line Width", "lineWidth", "1")
]


# =============================================================================
# Elements
# =============================================================================

Model.Shape = Model.Element.createVariant()
Model.Shape.addChildren [
  Model.Transform.createVariant()
]


Model.Group = Model.Shape.createVariant
  label: "Group"


Model.Anchor = Model.Shape.createVariant
  label: "Anchor"

createAnchor = (x, y) ->
  anchor = Model.Anchor.createVariant()
  transform = anchor.childOfType(Model.Transform)
  attributes = transform.getAttributesByName()
  attributes.x.setExpression(x)
  attributes.y.setExpression(y)


Model.PathComponent = Model.Component.createVariant
  label: "Path"

Model.PathComponent.addChildren [
  createAttribute("Close Path", "closed", "true")
]

Model.Path = Model.Shape.createVariant
  label: "Path"

Model.Path.addChildren [
  Model.PathComponent.createVariant()
  Model.Fill.createVariant()
  Model.Stroke.createVariant()
]


Model.Circle = Model.Path.createVariant
  label: "Circle"


Model.Rectangle = Model.Path.createVariant
  label: "Rectangle"

Model.Rectangle.addChildren [
  createAnchor("0.00", "0.00")
  createAnchor("0.00", "1.00")
  createAnchor("1.00", "1.00")
  createAnchor("1.00", "0.00")
]


Model.TextComponent = Model.Component.createVariant
  label: "Text"

Model.TextComponent.addChildren [
  createAttribute("Text", "text", '"Text"')
  createAttribute("Font", "fontFamily", '"Lucida Grande"')
  createAttribute("Color", "color", "rgba(0.20, 0.20, 0.20, 1.00)")
  createAttribute("Align", "textAlign", '"start"')
  createAttribute("Baseline", "textBaseline", '"alphabetic"')
]

Model.Text = Model.Shape.createVariant
  label: "Text"

Model.Text.addChildren [
  Model.TextComponent.createVariant()
]










