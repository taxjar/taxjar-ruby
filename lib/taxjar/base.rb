require 'addressable/uri'
require 'forwardable'
require 'memoizable'
require 'model_attribute'

if !Array.new.respond_to?(:to_h)
  module Enumerable
    def to_h(*arg)
      h = {}
      each_with_index(*arg) do |elem, i|
        unless elem.respond_to?(:to_ary)
          raise TypeError, "wrong element type #{elem.class} at #{i} (expected array)"
        end

        ary = elem.to_ary
        if ary.size != 2
          raise ArgumentError, "wrong array length at #{i} (expected 2, was #{ary.size})"
        end

        h[ary[0]] = ary[1]
      end
      h
    end
  end
end

module Taxjar
  class Base
    extend Forwardable
    include Memoizable

    attr_reader :attrs
    alias_method :to_h, :attrs
    alias_method :to_hash, :to_h

    def map_collection(klass, key)
      Array(@attrs[key.to_sym]).map do |entity|
        klass.new(entity)
      end
    end

    class << self

      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      def object_attr_reader(klass, key1, key2 = nil)
        define_attribute_method(key1, klass, key2)
        define_predicate_method(key1)
      end

      def define_attribute_method(key1, klass = nil, key2 = nil)
        define_method(key1) do
          if attr_falsey_or_empty?(key1)
          else
            klass.nil? ? @attrs[key1] : klass.new(attrs_for_object(key1, key2))
          end
        end
        memoize(key1)
      end

      def define_predicate_method(key1, key2 = key1)
        define_method(:"#{key1}?") do
          !attr_falsey_or_empty?(key2)
        end
        memoize(:"#{key1}?")
      end
    end

    def initialize(attributes = {})
      @attrs = set_attributes(attributes)
    end

    def [](method)
      warn "#{Kernel.caller.first}: [DEPRECATION] #[#{method.inspect}] is deprecated. Use ##{method} to fetch the value."
      send(method.to_sym)
    rescue NoMethodError
      nil
    end

  private

    def attr_falsey_or_empty?(key)
      !@attrs[key] || @attrs[key].respond_to?(:empty?) && @attrs[key].empty?
    end

    def attrs_for_object(key1, key2 = nil)
      if key2.nil?
        @attrs[key1]
      else
        attrs = @attrs.dup
        attrs.delete(key1).merge(key2 => attrs)
      end
    end
  end
end
