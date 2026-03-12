# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Testing variables', type: :feature do
  context 'when creating a new variable' do
    let(:evaluator) { Syntax::Evaluator }

    before do
      @eval = ->(root, variables) { evaluator.new(root, variables).eval! }
    end

    describe 'creates a new variable' do
      let(:var_1) { 'a = 1' }
      let(:var_2) { 'b = 2' }
      let(:add) { 'c = a + b' }

      it 'creates the two variables and adds them' do
        text = [var_1, var_2, add].join("\n")
        tree = Syntax::SyntaxTree.parse(text)

        expect(tree.diagnostics).to be_empty

        variables = {}
        @eval.call(tree.root, variables)

        binding.pry
        expect(variables['a']).to eq(1)
        expect(variables['b']).to eq(2)
        expect(variables['c']).to eq(3)
      end
    end
  end
end
