require 'ruby-debug'
require 'bond'

module Debugger
  module Completion
    extend self
    VERSION = '0.1.0'
    COMMANDS = [ "backtrace", "break", "catch", "condition", "continue",
      "delete", "disable", "display", "down", "edit", "enable", "eval", "exit",
        "finish", "frame", "help", "info", "irb", "list", "method", "next",
        "p", "pp", "ps", "putl", "quit", "reload", "restart", "save", "set",
        "show", "source", "step", "thread", "tmate", "trace", "undisplay",
        "up", "var", "where"
    ]
    COMMANDS << ['jump'] if RUBY_VERSION >= '1.9'

    def start
      Bond.start(:default_mission=>lambda {|e| Debugger::Completion.default_action }) do
        complete(:methods=>%w{catch cat}) { objects_of(Class).select {|e| e < StandardError } }
        complete(:methods=>%w{disable enable}) { %w{breakpoints display} }
        complete(:methods=>['help', 'h']) { Debugger::Completion.commands }
        complete(:method=>'info') { %w{args breakpoints catch display file files} +
          %w{global_variables instance_variables line locals program stack thread} +
          %w{threads variables}
        }
        complete(:methods=>%w{set show}) { %w{annotate args autoeval autolist autoirb} +
          %w{basename callstyle debuggertesting forcestep fullpath history} +
          %w{keep-frame-bindings linetrace+ linetrace listsize trace width}
        }
        complete(:methods=>%w{quit exit q}) { %w{unconditionally} }
        complete(:methods=>%w{save source}, :action=>:files)
        complete(:methods=>%w{thread th}) { %w{list stop resume switch current} }
        complete(:methods=>%w{trace tr}) { %w{on off var} }
        complete(:methods=>%w{var v}) { %w{class const global instance local} }
      end
    end

    def commands; COMMANDS; end

    def default_action
      completions = commands
      if @irb_completion
        eval_string = "methods | private_methods | local_variables | self.class.constants"
        completions += Bond::Mission.current_eval(eval_string) | Bond::DefaultMission::ReservedWords
      end
      completions
    end

    def toggle_irb_completion
      @irb_completion = !@irb_completion
    end
  end
end

Debugger::Completion.start
