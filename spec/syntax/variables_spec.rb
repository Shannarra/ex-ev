# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Testing variables', type: :feature do
  context 'when creating a new variable' do
    let(:evaluator) { Syntax::Evaluator }
    let(:variables) { {} }

    before do
      @eval = ->(root, variables) { evaluator.new(root, variables).eval! }
    end

    def perform!(text)
      lines = text.split("\n")

      lines.each do |line|
        tree = Syntax::SyntaxTree.parse(line)

        expect(tree.diagnostics).to be_empty
        @eval.call(tree.root, variables)
      end
    end

    describe 'creates variables correctly' do
      let(:text) do
        <<TEXT
          a = 1
          b = 2
          c = a + b
TEXT
      end

      it 'creates two variables and adds them' do
        perform! text

        expect(variables['a']).to eq(1)
        expect(variables['b']).to eq(2)
        expect(variables['c']).to eq(3)
      end

      let(:text2) do
        <<TEXT
         number = 17.5
         part_one = number * 2
         another_number = 12.3
         yet_another_number = 21.7
         part_two = another_number + yet_another_number
         the_best_number_ever = part_one + part_two
TEXT
      end

      it 'calculates the best number ever' do
        perform! text2

        expect(variables['the_best_number_ever']).to eq(69)

        # make sure that the previous example's variables are not affecting the current one
        expect(variables['a']).to be_nil
        expect(variables['b']).to be_nil
        expect(variables['c']).to be_nil
      end

      let!(:text_with_complex_variables) do
        <<TEXT
          thirty_seven      = 5*10-(8*6-15)+4*20/4
          n_nineteen        = 3*(4**2)+8-((11+4)**2)/3
          fifty_six         = 7*9+3-6/2+2*2-11
          two               = 11+3-7*2+1*4/2
          n_fifty_one       = 12/(1+3)-9*6
          n_277k            = 2+2+2+22+2+2*954-6**7+3/65
          two_seventy_seven = ((11*22+33-44)**5)/((6**7)*8+9**9)*(69/420)
          result = thirty_seven + n_nineteen + fifty_six + two + n_fifty_one + n_277k + two_seventy_seven
TEXT
      end
      let(:expected_result) { -277_695.639_560_439_57 }

      it 'can create complex variables and perform all calculations' do
        perform! text_with_complex_variables

        expect(variables['result']).to eq expected_result
      end
    end
  end
end
