# frozen_string_literal: true

require "./server"
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir("./calculator")
loader.setup

run Server.freeze.app
