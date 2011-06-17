# Stella Demo Rackup
#
# Usage:
# 
#     $ thin -e dev -R config.ru -p 7143 start

ENV['RACK_ENV'] ||= 'production'
ENV['APP_ROOT'] = ::File.expand_path(::File.join(::File.dirname(__FILE__)))
$:.unshift(::File.join(ENV['APP_ROOT']))
$:.unshift(::File.join(ENV['APP_ROOT'], 'lib'))
$:.unshift(::File.join(ENV['APP_ROOT'], 'app'))

require 'bundler'
Bundler.require

require 'syslog'
require 'otto'
require 'app/site'

PUBLIC_DIR = "#{ENV['APP_ROOT']}/public/site"

SYSLOG = Syslog.open('ots')
SYSLOG.alert "hihi"

otto = Otto.new("#{ENV['APP_ROOT']}/app/routes")
otto.option[:public] = PUBLIC_DIR

if Otto.env?(:dev)
  map("/") {
    use Rack::CommonLogger
    use Rack::Reloader, 0
    run otto
  }
else
  map("/")        { run otto }
end

map("/etc/")      { run Rack::File.new("#{PUBLIC_DIR}/etc") }
map("/img/")      { run Rack::File.new("#{PUBLIC_DIR}/img") }
