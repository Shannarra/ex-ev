# frozen_string_literal: true

require_relative 'lexer'
require_relative 'base'

module Syntax
  module ParsingHelpers
    def binary_operator_precedence(kind)
      case kind
      when SyntaxKind::StarToken, SyntaxKind::SlashToken, SyntaxKind::DoubleStarToken then 2
      when SyntaxKind::PlusToken, SyntaxKind::MinusToken then 1
      else 0
      end
    end
  end

  class Parser
    include ParsingHelpers

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
        token = lexer.lex!
        break if token.nil?

        tokens << token unless [SyntaxKind::WhitespaceToken, SyntaxKind::BadToken].include? token.kind
      end

      # append last token IF it's good
      next_tok = lexer.lex!
      tokens << token unless [SyntaxKind::WhitespaceToken, SyntaxKind::BadToken].include? next_tok.kind

      @tokens = Array(tokens)
      @diagnostics << lexer.diagnostics
    end

    def parse
      expr = parse_expression
      eof = match(SyntaxKind::EOFToken)

      SyntaxTree.new(@diagnostics, expr, eof)
    end

    def parse_expression(parent_precedence = 0)
      left = parse_factor

      loop do
        precedence = binary_operator_precedence(current.kind)
        break if precedence.zero? || precedence <= parent_precedence

        operator = next_token
        right = parse_expression(precedence)
        left = BinaryExpressionSyntax.new(left, operator, right)
      end

      left
    end

    private

    def peek(offset = 1)
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

      while [SyntaxKind::StarToken, SyntaxKind::SlashToken].include? current.kind
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
        expr = parse_expression
        right = match(SyntaxKind::CloseParenthesisToken)
        return ParenthesizedExpressionSyntax.new(left, expr, right)
      elsif current.kind == SyntaxKind::IdentifierToken
        return parse_id
      end

      num = match(SyntaxKind::NumberToken)
      NumberExpressionSyntax.new(num)
    end

    def parse_id
      id = next_token

      if current.kind == SyntaxKind::AssignmentToken
        _assignment_op = match(SyntaxKind::AssignmentToken)
        right = parse_expression # match(SyntaxKind::NumberToken) # parse_expression

        return AssignmentExpressionSyntax.new(id, right)
      end

      IdentifierExpressionSyntax.new(id)
    end
  end
end
