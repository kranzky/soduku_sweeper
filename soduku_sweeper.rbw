#!/usr/bin/env ruby

if __FILE__ == $0
    $LOAD_PATH << File.join(File.dirname(__FILE__), "include")
    require 'game'
    require 'view'
    application = Fox::FXApp.new
    view = View.new(application)
    game = Game.new
    game.add_observer(view)
    view.add_observer(game)
    application.create
    application.run
end
