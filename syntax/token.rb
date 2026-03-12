# frozen_string_literal: true

require_relative 'node'

module Syntax
  class Token < SyntaxNode
    attr_reader :position, :text, :value

    def initialize(kind, position, text, value)
      super(kind, []) # don't pass Token properties as children

      @position = position
      @text = text
      @value = value
    end
  end
end
