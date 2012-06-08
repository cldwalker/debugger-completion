## Description

Provides debugger with command and command arguments completion using a completion system
more powerful than irb's, compliments of [bond](http://github.com/cldwalker/bond).

## Install

Install the gem with:

    gem install debugger-completion

## Setup

To have debugger automatically use this gem:

    echo "eval require 'debugger/completion'" >> ~/.rdebugrc

Or to require in a script or application, place after your `require 'debugger'` line:

    require 'debugger/completion'

Or if you like to debug with one-liners:

    require 'debugger/completion'; debugger

Or if using rdebug:

    rdebug -r debugger/completion FILE

To start manually in environments with bond completion already setup i.e. irb:

    require 'debugger/completion'
    Debugger::Completion.start

## Usage

Let's autocomplete instance and local variables of the current binding as well as debugger
commands:

       186    end
       187
       188    def render
       189      body = []
       190      require 'debugger'; debugger
    => 191      unless @rows.length ## 0
       192        setup_field_lengths
       193        body += render_header
       194        body += render_rows
       195        body += render_footer

    (rdb:1) [TAB]
    @fields            condition          finish             ps                 thread
    @filter_classes    continue           frame              putl               tmate
    @headers           delete             help               quit               trace
    @options           disable            info               reload             undisplay
    @rows              display            irb                restart            up
    backtrace          down               list               save               var
    body               edit               method             set                where
    break              enable             next               show
    catch              eval               p                  source
    completion_toggle  exit               pp                 step

    (rdb:1) ca[TAB]
    (rdb:1) catch

    (rdb:1) @fie[TAB]
    (rdb:1) @fields

    (rdb:1) bo[TAB]
    (rdb:1) body

Autocomplete methods of local and instance variables:

    (rdb:1) @filter_classes.[TAB]
    Display all 150 possibilities? (y or n)

    (rdb:1) body.[TAB]
    Display all 168 possibilities? (y or n)


Autocomplete debugger command arguments:

    # What info does debugger provide?
    (rdb:1) info [TAB]
    args                display             global_variables    locals              thread
    breakpoints         file                instance_variables  program             threads
    catch               files               line                stack               variables

    (rdb: 1) info d[TAB]
    (rdb: 1) info display

    # What settings can I change?
    (rdb:1) set [TAB]
    annotate             autolist             forcestep            linetrace            width
    args                 basename             fullpath             linetrace+
    autoeval             callstyle            history              listsize
    autoirb              debuggertesting      keep-frame-bindings  trace

    (rdb:1) set d[TAB]
    (rdb:1) set debuggertesting

Since I have autoeval on, why not autocomplete as if I'm in irb?

    # Execute command provided by this gem
    (rdb:1) completion_toggle  # also aliased to ct

    # irb-like completion has been enabled
    (rdb:1) [TAB]
    Display all 347 possibilities? (y or n)

    (rdb:1) De[TAB]
    (rdb:1) Debugger
    (rdb:1) Debugger.[TAB]
    Display all 137 possibilities? (y or n)

    (rdb:1) require 'ab[TAB]
    (rdb:1) require 'abbrev.rb'

Huh? Argument autocompletion?
See [bond](http://github.com/cldwalker/bond) for all that you can autocomplete.

Can I go back to basic debugger completion?

    # Invoke completion_toggle again
    (rdb:1)  completion_toggle

    (rdb:1) [TAB]
    @fields            condition          finish             ps                 thread
    @filter_classes    continue           frame              putl               tmate
    @headers           delete             help               quit               trace
    @options           disable            info               reload             undisplay
    @rows              display            irb                restart            up
    backtrace          down               list               save               var
    body               edit               method             set                where
    break              enable             next               show
    catch              eval               p                  source
    completion_toggle  exit               pp                 step

Please, can I just quit quickly without a prompt?

    (rdb:1) q [TAB]
    (rdb:1) q unconditionally

## Bugs/Issues

Please report them [on github](http://github.com/cldwalker/debugger-completion/issues).
