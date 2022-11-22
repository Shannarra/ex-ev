# frozen_string_literal: true

require_relative '../utils'
require_relative '../syntax'
require_relative '../evaluation'
require 'pry'

RSpec.describe 'Testing numbers', type: :feature do
  context 'that have been correctly parsed' do
    before do
      @float_test_value = 69.69
      @int_test_value = 69
      @float_parser = Parser.new(@float_test_value.to_s)
      @int_parser = Parser.new(@int_test_value.to_s)
    end

    describe 'by constructing correct parsers' do
      it 'for integers and floats' do
        expect(@int_parser.class).to eq Parser
        expect(@float_parser.class).to eq Parser
      end
    end

    describe 'and have valid number types' do
      before do
        @int_tree = @int_parser.parse
        @float_tree = @float_parser.parse
      end

      it 'by constructing valid trees' do
        expect(@int_tree.class).to be SyntaxTree
        expect(@float_tree.class).to be SyntaxTree
      end

      it 'by having no errors or diagnostics' do
        expect(@int_tree.diagnostics).to eq []
        expect(@float_tree.diagnostics).to eq []
      end

      describe 'are expected to' do
        before do
          @int_root = @int_tree.root
          @float_root = @float_tree.root
        end

        it 'have correct types for integers' do
          expect(@int_root.is_a?(ExpressionSyntax)).to be true
          expect(@int_root.is_a?(NumberExpressionSyntax)).to be true
          expect(@int_root.token.kind).to eq SyntaxKind::NumberToken
          expect(@int_root.is_integer).to be true
        end

        it 'have correct types for floats' do
          expect(@float_root.is_a?(ExpressionSyntax)).to be true
          expect(@float_root.is_a?(NumberExpressionSyntax)).to be true
          expect(@float_root.token.kind).to eq SyntaxKind::NumberToken
          expect(@float_root.is_integer).to be false
        end

        it 'have correct INT value' do
          expect(@int_root.token.value).to eq @int_test_value
        end

        it 'have correct FLOAT value' do
          expect(@float_root.token.value).to eq @float_test_value
        end
      end
    end
  end

  context 'and operations performed on them' do
    before do
      @eval = ->(root) { Evaluator.new(root).eval! }
    end

    describe 'simple operations are working as expected' do
      before(:each) do
        @range = (1.0..10_000_000.0)
        @num1 = rand(@range)
        @num2 = rand(@range)
        @operation = ->(operator) { SyntaxTree.parse("#{@num1} #{operator} #{@num2}").root }
      end

      it 'adds correctly' do
        expect(@eval.call(@operation.call('+'))).to eq @num1 + @num2
      end
      it 'subtracts correctly' do
        expect(@eval.call(@operation.call('-'))).to eq @num1 - @num2
      end
      it 'multiplies correctly' do
        expect(@eval.call(@operation.call('*'))).to eq @num1 * @num2
      end
      it 'divides correctly' do
        expect(@eval.call(@operation.call('/'))).to eq @num1 / @num2
      end
    end

    describe 'more complex operations are evaluated correctly' do
      before do
        @expressions = {
          '5*10-(8*6-15)+4*20/4': 37,
          '3*(4**2)+8-((11+4)**2)/3': -19,
          '7*9+3-6/2+2*2-11': 56,
          '11+3-7*2+1*4/2': 2,
          '12/(1+3)-9*6': -51,
          '2+2+2+22+2+2*954-6**7+3/65': -277_997.95384615386,
          '((11*22+33-44)**5)/((6**7)*8+9**9)*(69/420)': 277.3142857142857
        }
      end

      it 'evaluates harder examples correctly' do
        @expressions.each do |text, value|
          result_tree = SyntaxTree.parse(text)
          throw result_tree.diagnostics.join unless result_tree.diagnostics.empty? # prevent unexpected characters

          expect(@eval.call(result_tree.root)).to be value
        end
      end
    end
  end
end
