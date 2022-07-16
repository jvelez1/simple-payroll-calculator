# frozen_string_literal: true

require "./server"
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir("./lib")
loader.push_dir("./calculator")
loader.push_dir("./")
loader.setup

run Server.freeze.app
