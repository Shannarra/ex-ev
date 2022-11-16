# frozen_string_literal: true

class SyntaxNode
  attr_reader :kind

  def get_children(); end
end

class ExpressionSyntax < SyntaxNode; end

class BinaryExpressionSyntax
  attr_reader :kind, :left, :operator, :right

  def initialize(left, operator, right)
    super()
    @kind = SyntaxKind::BinaryExpression
    @left = left
    @operator = operator
    @right = right
  end

  def get_children
    if block_given?
      yield @left
      yield @operator
      yield @right
    else
      [@left, @operator, @right]
    end
  end
end

class Token < SyntaxNode
  attr_reader :kind, :position, :text, :value

  def initialize(kind, position, text, value)
    super()
    @kind = kind
    @position = position
    @text = text
    @value = value
  end

  def get_children
    []
  end
end
