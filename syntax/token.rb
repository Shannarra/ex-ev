# frozen_string_literal: true

class SyntaxNode
  attr_reader :kind

  def initialize(kind, children)
    @kind = kind
    @children = Array(children)
  end

  def children(&block)
    return @children.each(&block) if block_given?

    @children
  end
end

class ExpressionSyntax < SyntaxNode
  def initialize(kind, children)
    super(kind, children)
    @children = children
  end
end

class BinaryExpressionSyntax < ExpressionSyntax
  attr_reader :left, :operator, :right

  def initialize(left, operator, right)
    super(SyntaxKind::BinaryExpression, [left, operator, right])
    @left = left
    @operator = operator
    @right = right
  end
end

class Token < SyntaxNode
  attr_reader :position, :text, :value

  def initialize(kind, position, text, value)
    super(kind, []) # don't pass Token properties as children

    @position = position
    @text = text
    @value = value
  end
end
