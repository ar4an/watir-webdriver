require 'yaml'

module Watir
  class Cookies
    def initialize(control)
      @control = control
    end

    #
    # Returns array of cookies.
    #
    # @example
    #   browser.cookies.to_a
    #   #=> {:name=>"my_session", :value=>"BAh7B0kiD3Nlc3Npb25faWQGOgZFRkk", :domain=>"mysite.com"}
    #
    # @return [Array<Hash>]
    #

    def to_a
      @control.all_cookies.each do |e|
        e[:expires] = to_time(e[:expires]) if e[:expires]
      end
    end

    #
    # Adds new cookie.
    #
    # @example
    #   browser.cookies.add 'my_session', 'BAh7B0kiD3Nlc3Npb25faWQGOgZFRkk', :secure => true
    #
    # @param [String] name
    # @param [String] value
    # @param [Hash] opts
    # @option opts [Boolean] :secure
    # @option opts [String] :path
    # @option opts [] :expires  TODO what type
    # @option opts [String] :domain
    #

    def add(name, value, opts = {})
      cookie = {
        :name    => name,
        :value   => value,
        :secure  => opts[:secure],
        :path    => opts[:path],
        :expires => opts[:expires],
      }

      if opts[:domain]
        cookie[:domain] = opts[:domain]
      end

      @control.add_cookie cookie
    end

    #
    # Deletes cookie by given name.
    #
    # @example
    #   browser.cookies.delete 'my_session'
    #
    # @param [String] name
    #

    def delete(name)
      @control.delete_cookie(name)
    end

    #
    # Deletes all cookies.
    #
    # @example
    #   browser.cookies.clear
    #

    def clear
      @control.delete_all_cookies
    end

    #
    # Save cookies to file
    #
    # @example
    #   browser.cookies.save '.cookies'
    #
    # @param [String] file
    #

    def save(file = '.cookies')
      IO.write(file, to_a.to_yaml)
    end

    #
    # Load cookies from file
    #
    # @example
    #   browser.cookies.load '.cookies'
    #
    # @param [String] file
    #

    def load(file = '.cookies')
      YAML.load(IO.read(file)).each do |c|
        add c[:name], c[:value], path: c[:path], domain: c[:domain], expires: c[:expires], secure: c[:secure]
      end
    end

    private

    def to_time(t)
      if t.respond_to?(:to_time)
        t.to_time
      else
        ::Time.local t.year, t.month, t.day, t.hour, t.min, t.sec
      end
    end
  end
end

