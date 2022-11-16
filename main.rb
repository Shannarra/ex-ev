#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

require 'pry'

require_relative 'utils'
require_relative 'syntax'
require_relative 'evaluation'

def pretty_print_tree(root, indent = '', is_last: true)
  marker = is_last ? '└───' : '├───'

  print "#{indent}#{marker}#{root.kind}"

  print " #{root.value}" if root.is_a?(Token) && !root.value.nil?
  puts ''

  indent += is_last ? '    ' : '│   '
  last_child = root.get_children[-1]

  root.get_children do |child|
    pretty_print_tree(child, indent, child == last_child)
  end
end

def repl_loop(show_tree)
  loop do
    print '> '
    line = gets.strip
    return if line.empty?

    case line
    when '#clear', '#c', '#cls'
      system('clear')
      next
    when '#printTree', '#print', '#p'
      show_tree = !show_tree
      puts "#{show_tree ? '' : 'Not '}Showing Tree"
      next
    when '#exit', '#e', '#quit', '#q'
      return
    end

    tree = SyntaxTree.parse(line)

    pretty_print_tree(tree.root) if show_tree

    if tree.diagnostics.flatten.count.positive?
      tree.diagnostics.each do |diagnostic|
        eputs diagnostic
      end
    else
      evaluator = Evaluator.new(tree.root)
      res = evaluator.eval!

      puts res
    end
  end
end

def main
  debug_show_tree = false
  ARGV.each do |x|
    case x
    when '--showTree', '-st', '--debugPrint', '-dp' then debug_show_tree = true
    else
      wputs "Unrecognized cli argument \"#{x}\". Running with default configuration."
    end
  end.clear

  repl_loop(debug_show_tree)
end

main
