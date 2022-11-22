# frozen_string_literal: true

class Evaluator
  def initialize(root)
    @root = root
  end

  def eval!
    evaluate_expr! @root
  end

  private

  def evaluate_expr!(expr)
    if expr.is_a? NumberExpressionSyntax
      value = expr.token.value

      return expr.is_integer ? Integer(value) : Float(value)
    end

    if expr.is_a? BinaryExpressionSyntax
      left = evaluate_expr!(expr.left)
      right = evaluate_expr!(expr.right)

      case expr.operator.kind
      when SyntaxKind::PlusToken then return left + right
      when SyntaxKind::MinusToken then return left - right
      when SyntaxKind::StarToken then return left * right
      when SyntaxKind::SlashToken
        denom = right
        denom = right.to_f if right > left || right.is_a?(Float)

        return left / denom
      when SyntaxKind::DoubleStarToken then return left**right
      else raise "Unexpected binary operator #{expr.operator.kind}".error!
      end
    end

    return evaluate_expr! expr.expression if expr.is_a? ParenthesizedExpressionSyntax

    raise "Unexpected node #{expr.kind}".error!
  end
end
