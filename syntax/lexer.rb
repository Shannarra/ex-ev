# frozen_string_literal: true

require_relative 'token'

module Syntax
  class Lexer
    attr_reader :diagnostics

    def initialize(text)
      @text = text
      @diagnostics = []
      @position = 0
    end

    def lex!
      return Token.new(SyntaxKind::EOFToken, @position, '\0', nil) if @position >= @text.length

      return handle_numeric if current.numeric?

      return handle_whitetext if [' ', "\n", "\t"].include? current

      type = case current
             when '+'
               SyntaxKind::PlusToken
             when '-'
               SyntaxKind::MinusToken
             when '*'
               SyntaxKind::StarToken
             when '/'
               SyntaxKind::SlashToken
             when '('
               SyntaxKind::OpenParenthesisToken
             when ')'
               SyntaxKind::CloseParenthesisToken
             when '='
               SyntaxKind::AssignmentToken
             else
               token = ''
               until [' ', '=', '\0'].include?(current)
                 token += current
                 get_next
               end

               return Token.new(SyntaxKind::IdentifierToken, @position, token, token)
             end

      return Token.new(type, @position += 1, current, nil) if type

      @diagnostics << "Bad character input: '#{current}'"
      Token.new(SyntaxKind::BadToken, @position += 1, @text[@position - 1], nil)
    end

    private

    def handle_numeric
      start = @position

      get_next while current.numeric?

      text = @text[start...@position]
      num = nil

      begin
        num = if current == '.'
                get_next
                get_next while current.numeric?

                text = @text[start...@position]
                Float(text)
              else
                Integer(text)
              end
      rescue ArgumentError
        @diagnostics << "[ERROR] \"#{text}\" is not a valid number!"
      end

      Token.new(SyntaxKind::NumberToken, start, text, num)
    end

    def handle_whitetext
      case current
      when ' '
        start = @position
        get_next while current == ' '

        text = @text[start...@position]
        Token.new(SyntaxKind::WhitespaceToken, start, text, nil)
      when "\n"
        initial = current
        start = @position

        get_next while current == initial
        text = @text[start..@position]
        Token.new(SyntaxKind::NewlineToken, start, text, nil)
      when "\t"
        initial = current
        start = @position

        get_next while current == initial
        text = @text[start..@position]
        Token.new(SyntaxKind::TabToken, start, text, nil)
      else
        raise "Unhandled whitespace character #{current}".error!
      end
    end

    def current
      return '\0' if @position >= @text.length

      @text[@position]
    end

    # rubocop:disable Naming/AccessorMethodName
    def get_next
      @position += 1
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
