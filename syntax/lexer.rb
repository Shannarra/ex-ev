# frozen_string_literal: true

require_relative 'token'

class Lexer
  attr_reader :diagnostics

  def initialize(text)
    @text = text
    @diagnostics = []
    @position = 0
  end

  def next_token
    return Token.new(SyntaxKind::EOFToken, @position, '\0', nil) if @position >= @text.length

    if current.numeric?
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

      return Token.new(SyntaxKind::NumberToken, start, text, num)
    end

    if current == ' '
      start = @position
      get_next while current == ' '

      text = @text[start...@position]
      return Token.new(SyntaxKind::WhitespaceToken, start, text, nil)
    end

    case current
    when '+'
      return Token.new(SyntaxKind::PlusToken, @position += 1, current, nil)
    when '-'
      return Token.new(SyntaxKind::MinusToken, @position += 1, current, nil)
    when '*'
      return Token.new(SyntaxKind::StarToken, @position += 1, current, nil)
    when '/'
      return Token.new(SyntaxKind::SlashToken, @position += 1, current, nil)
    when '('
      return Token.new(SyntaxKind::OpenParenthesisToken, @position += 1, current, nil)
    when ')'
      return Token.new(SyntaxKind::CloseParenthesisToken, @position += 1, current, nil)
    end

    @diagnostics << "Bad character input: '#{current}'"
    Token.new(SyntaxKind::BadToken, @position += 1, @text[@position - 1], nil)
  end

  private

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
