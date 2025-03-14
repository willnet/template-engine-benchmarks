#!/usr/bin/env ruby

require 'bundler/inline'
require_relative 'context'

gemfile do
  source 'https://rubygems.org'
  gem 'benchmark-ips'
  gem 'slim'
  gem 'haml'
  gem 'erubi'
end

class TemplateEngineBenchmarks
  def initialize
    @benches   = []

    @erb_code  = File.read(File.dirname(__FILE__) + '/view.erb')
    @haml_code = File.read(File.dirname(__FILE__) + '/view.haml')
    @slim_code = File.read(File.dirname(__FILE__) + '/view.slim')

    init_compiled_benches
  end

  def init_compiled_benches
    context = Context.new

    context.instance_eval %{
      def run_erubi; #{Erubi::Engine.new(@erb_code).src}; end
      def run_slim; #{Slim::Engine.new.call(@slim_code)}; end
      def run_haml; #{Haml::Engine.new.call(@haml_code)}; end
    }

    bench("erubi v#{Erubi::VERSION}") { context.run_erubi }
    bench("slim v#{Slim::VERSION}")   { context.run_slim }
    bench("haml v#{Haml::VERSION}")   { context.run_haml }
  end

  def run
    Benchmark.ips do |x|
      @benches.each do |name, block|
        x.report(name.to_s, &block)
      end
      x.compare!
    end
  end

  def bench(name, &block)
    @benches.push([name, block])
  end
end

TemplateEngineBenchmarks.new.run
