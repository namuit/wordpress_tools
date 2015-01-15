require 'wordpress_tools/cli'
require 'fakeweb'
require 'thor'

RSpec.configure do |config|
  $stdout = StringIO.new
  FileUtils.mkdir('tmp') unless File.directory? 'tmp'

  FakeWeb.allow_net_connect = false
  WP_API_RESPONSE = <<-eof
      upgrade
      http://wordpress.org/download/
      http://wordpress.org/wordpress-3.6.zip
      3.6
      en_US
      5.2.4
      5.0
  eof
  FakeWeb.register_uri(:get, %r|http://api.wordpress.org/core/version-check/1.5/.*|, :body => WP_API_RESPONSE)
  FakeWeb.register_uri(:get, "http://wordpress.org/wordpress-3.6.zip", :body => File.expand_path('spec/fixtures/wordpress_stub.zip'))

end

