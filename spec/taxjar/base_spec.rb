require 'helper'

describe Taxjar::Base do
  describe "#initialize" do
    before do
      @klass = Class.new(Taxjar::Base)
      @klass.attr_reader(:field)
    end

    it 'should convert string fields to floats if it can be done' do
      b = @klass.new(:field => '3.0')
      expect(b.field).to eq(3.0)
    end

    it 'should convert string fields to integers if it can be done' do
      b = @klass.new(:field => '3')
      expect(b.field).to eq(3)
    end

    it 'it should leave string as strings' do
      b = @klass.new(:field => 'a')
      expect(b.field).to eq('a')
    end
  end
end
