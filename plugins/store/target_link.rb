#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Store::TargetLink
# Author::    774 <http://id774.net>
# Created::   Feb 28, 2012
# Updated::   Feb 28, 2012
# Copyright:: 774 Copyright (c) 2012
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class StoreTargetLink
    require 'open-uri'

    def initialize(config, pipeline=[])
      @config = config
      @pipeline = pipeline
    end

    def wget(url)
      filename = url.split(/\//).last
      open(url) do |source|
        open(File.join(@config['path'], filename), "w+b") do |o|
          o.print source.read
        end
      end
    end

    def run
      @pipeline.each {|feeds|
        unless feeds.nil?
          feeds.items.each {|feed|
            begin
              unless feed.link.nil?
                Automatic::Log.puts("info", "Wget: #{feed.link}")
                wget(feed.link)
              end
            rescue
              Automatic::Log.puts("error", "Error found during file download.")
            end
            sleep @config['interval'].to_i
          }
        end
      }
      @pipeline
    end
  end
end
