require 'ruby-debug'
require 'bond'

module Debugger
  module Completion
    extend self
    VERSION = '0.1.1'
    COMMANDS = [ "backtrace", "break", "catch", "condition", "continue",
      "delete", "disable", "display", "down", "edit", "enable", "eval", "exit",
        "finish", "frame", "help", "info", "irb", "list", "method", "next",
        "p", "pp", "ps", "putl", "quit", "reload", "restart", "save", "set",
        "show", "source", "step", "thread", "tmate", "trace", "undisplay",
        "up", "var", "where"
    ]
    COMMANDS << ['jump'] if RUBY_VERSION >= '1.9'

    def start
      Bond.start(:eval_binding=>lambda { Debugger::Completion.current_binding },
                 :default_mission=>lambda {|e| Debugger::Completion.default_action }) do
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
      completions = commands + ['completion_toggle']
      if @irb_completion
        eval_string = "methods | private_methods | local_variables | " +
          "self.class.constants | instance_variables"
        completions += debugger_eval(eval_string) | Object.constants |
          Bond::DefaultMission::ReservedWords
      else
        completions += debugger_eval("local_variables | instance_variables")
      end
      completions - ['__dbg_verbose_save']
    end

    def debugger_eval(string)
      eval string, current_binding || TOPLEVEL_BINDING
    end

    def current_binding
      (cmd = first_object(Debugger::Command)) && cmd.send(:get_binding) rescue nil
    end

    def first_object(klass)
      ObjectSpace.each_object(klass) {|e| return e }
      nil
    end

    def toggle_irb_completion
      @irb_completion = !@irb_completion
    end

    module Command
      def completion_toggle
        Completion.toggle_irb_completion
      end
      alias_method :ct, :completion_toggle
    end
  end
end

Object.send :include, Debugger::Completion::Command
Debugger::Completion.start
