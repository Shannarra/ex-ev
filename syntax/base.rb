# frozen_string_literal: true

require_relative 'parser'
require_relative 'node'

module Syntax
  SyntaxKind = enum %w[
    NumberToken
    WhitespaceToken
    PlusToken
    MinusToken
    StarToken
    DoubleStarToken
    SlashToken
    OpenParenthesisToken
    CloseParenthesisToken
    BadToken
    EOFToken
    NumberExpression
    BinaryExpression
    ParenthesizedExpression

    AssignmentToken
    IdentifierToken
  ]

  class SyntaxTree
    attr_reader :diagnostics, :root, :eof_token

    def initialize(diagnostics, root, eof_token)
      @diagnostics = diagnostics.flatten
      @root = root
      @eof_token = eof_token
    end

    class << self
      def parse(text)
        parser = Parser.new(text)

        parser.parse
      end
    end
  end
end
