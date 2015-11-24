require 'helper'

describe Taxjar::Error do
  describe 'attributes' do
    let(:error) { Taxjar::Error.new('unprocessable entity', 422)}

    describe "#code" do
      it 'returns the error code' do
        expect(error.code).to eq(422)
      end
    end

    describe "#message" do
      it 'returns the message' do
        expect(error.message).to eq('unprocessable entity')
      end
    end
  end

end
