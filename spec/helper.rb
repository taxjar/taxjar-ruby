require 'taxjar'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'coveralls.io')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


def a_get(path)
  a_request(:get, Taxjar::API::Request::BASE_URL + path)
end

def stub_get(path)
  stub_request(:get, Taxjar::API::Request::BASE_URL + path)
end

def fixture_path
    File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
    File.new(fixture_path + '/' + file)
end

