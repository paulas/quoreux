#!/usr/bin/env rackup
# encoding: utf-8

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'rubygems'
require 'bundler/setup'

require 'sinatra'

Bundler.require(:default, Sinatra::Application.environment)

require './quoreux'
run Quoreux

# vim: filetype=ruby
