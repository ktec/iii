require 'cgi'
require 'encryptor'
require 'mechanize'
require "highline/import"
#require 'highline'

#include Highline
module Iii
  class AuthenticationError < RuntimeError; end
	class Site
    class << self
      SECRET = "11eb254257566c6923c45bd84b570e100606463ab64c860ead9a94c8dace07f81465ed87d2fe7b531eb8d877e2afe33a39590237d34c12d324f717e8e79972eb"
      CONFIG_FILE = File.expand_path('~/.iiirc')
      def set_credentials(username,password)
        if username.empty? and password.empty?
          Encryptor.default_options.merge!(:key => Digest::SHA256.hexdigest(SECRET))
          begin
            config = YAML.load_file(CONFIG_FILE)
            raise if config[:credentials].empty?
          rescue
            config = ask_for_credentials
            credentials = config[:credentials]
          end
          credentials = config[:credentials]
          @username = credentials[:username]
          @password = credentials[:password].decrypt
        else
          @username = username
          @password = password
        end
        browser
      end

      def ask_for_credentials
        puts "To access the website we'll need your III website credentials."
        username = ask( "Enter your username:  " )
        password = ask( "Enter your password:  " ) { |q| q.echo = false }
        config = {
          :credentials => {
            :username => username.to_s,
            :password => password.encrypt.to_s
          }
        }
        write(CONFIG_FILE, config) if agree( "Do you want me to save these details?", true )
        config
      end

      def write(filename, hash)
        File.open(filename, 'w') do |f|
          output = hash.to_yaml
          f.write(output)
        end
      end

      def browser
        @browser ||= authenticate
      end

      def authenticate
        browser = Mechanize.new
        browser.robots = false
        begin
          login_page = browser.get("http://www.iii.co.uk/reg/?lo=3")
        rescue Mechanize::ResponseCodeError => exception
          if exception.response_code == '403'
            login_page = exception.page
          else
            raise # Some other error, re-raise
          end
        end
        begin
          page = login_page.form_with({:name => "login_form"}) do |f|
            f.field_with(:id => 'iii-username').value = @username
            f.field_with(:id => 'iii-password').value = @password
          end.submit
        rescue Mechanize::ResponseCodeError => exception
          if exception.response_code == '403'
            page = exception.page
            #puts page.body
          else
            raise # Some other error, re-raise
          end
        end
        begin
          page = page.form_with({:name => "show_login_redirect"}).submit
        rescue
          write(CONFIG_FILE, {})
          raise AuthenticationError
        end
        #p page.body if page.body !~ /Sign out/
        browser
      end

      def get(uri)
        Nokogiri::HTML(browser.get(URI.parse(uri)).body)
      end

    end

	end
end
