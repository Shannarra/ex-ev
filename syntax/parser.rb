# frozen_string_literal: true

require_relative 'lexer'

class Parser
  attr_reader :diagnostics

  def initialize(text)
    @text = text
    @tokens = []
    @diagnostics = []
    @position = 0

    tokens = []
    lexer = Lexer.new(text)
    token = nil

    until !token.nil? && token.kind == SyntaxKind::EOFToken
      token = lexer.next_token
      break if token.nil?

      tokens << token unless token.kind == SyntaxKind::WhitespaceToken || token.kind == SyntaxKind::BadToken
    end

    # append last token IF it's good
    next_tok = lexer.next_token
    tokens << token unless next_tok.kind == SyntaxKind::WhitespaceToken || next_tok.kind == SyntaxKind::BadToken

    @tokens = Array(tokens)
    @diagnostics << lexer.diagnostics
  end

  def parse
    expr = parse_term
    eof = match(SyntaxKind::EOFToken)

    SyntaxTree.new(@diagnostics, expr, eof)
  end

  def parse_term
    left = parse_factor

    while current.kind == SyntaxKind::PlusToken || current.kind == SyntaxKind::MinusToken
      operator = next_token
      right = parse_factor
      left = BinaryExpressionSyntax.new(left, operator, right)
    end

    left
  end

  private

  def peek(offset)
    id = @position + offset
    return tokens[-1] if id >= @tokens.count

    @tokens[id]
  end

  def current
    peek(0)
  end

  def next_token
    curr = current
    @position += 1
    curr
  end

  def match(kind)
    return next_token if current.kind == kind

    diagnostics << "Unexpected token <#{current.kind}>. Expected <#{kind}>"
    Token.new(kind, current.position, nil, nil)
  end

  def parse_factor
    left = parse_primary_expr

    while current.kind == SyntaxKind::StarToken || current.kind == SyntaxKind::SlashToken
      operator = if current.kind == SyntaxKind::StarToken && peek(1)&.kind == SyntaxKind::StarToken
                   next_token
                   next_token
                   operator = Token.new(SyntaxKind::DoubleStarToken, current.position, '**', nil)
                 else
                   next_token
                 end

      right = parse_primary_expr
      left = BinaryExpressionSyntax.new(left, operator, right)
    end

    left
  end

  def parse_primary_expr
    if current.kind == SyntaxKind::OpenParenthesisToken
      left = next_token
      expr = parse_term
      right = match(SyntaxKind::CloseParenthesisToken)
      return ParenthesizedExpressionSyntax.new(left, expr, right)
    end

    num = match(SyntaxKind::NumberToken)
    NumberExpressionSyntax.new(num)
  end
end

class NumberExpressionSyntax < ExpressionSyntax
  attr_reader :kind, :token, :is_integer

  def initialize(token)
    super()
    @token = token
    @is_integer = token.value.is_a? Integer
  end

  def get_children
    yield @token if block_given?

    [@token]
  end
end

class ParenthesizedExpressionSyntax < ExpressionSyntax
  attr_reader :kind, :open_token, :expression, :closed_token

  def initialize(open_token, expression, closed_token)
    super()
    @kind = SyntaxKind::ParenthesizedExpression
    @open_token = open_token
    @expression = expression
    @closed_token = closed_token
  end

  def get_children
    if block_given?
      yield @open_token
      yield @expression
      yield @closed_token
    else
      [@open_token, @expression, @closed_token]
    end
  end
end
