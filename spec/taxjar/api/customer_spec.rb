require 'helper'

describe Taxjar::API::Order do
  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe "#list_customers" do
    context "without parameters" do
      before do
        stub_get('/v2/customers').to_return(body: fixture('customers.json'),
                  headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'requests the right resource' do
        @client.list_customers
        expect(a_get('/v2/customers')).to have_been_made
      end

      it 'returns the requested customers' do
        customers = @client.list_customers
        expect(customers).to be_an Array
        expect(customers.first).to be_a String
        expect(customers.first).to eq('123')
      end
    end
  end

  describe "#show_customer" do
    before do
        stub_get('/v2/customers/123').
          to_return(body: fixture('customer.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.show_customer('123')
      expect(a_get('/v2/customers/123')).to have_been_made
    end

    it 'returns the requested customer' do
      customer = @client.show_customer('123')
      expect(customer).to be_an Taxjar::Customer
      expect(customer.customer_id).to eq('123')
      expect(customer.exemption_type).to eq('wholesale')
      expect(customer.name).to eq('Dunder Mifflin Paper Company')
      expect(customer.country).to eq('US')
      expect(customer.state).to eq('PA')
      expect(customer.zip).to eq('18504')
      expect(customer.city).to eq('Scranton')
      expect(customer.street).to eq('1725 Slough Avenue')
    end

    it 'allows access to exempt_regions' do
      customer = @client.show_customer('123')
      expect(customer.exempt_regions[0].country).to eq('US')
      expect(customer.exempt_regions[0].state).to eq('FL')
      expect(customer.exempt_regions[1].country).to eq('US')
      expect(customer.exempt_regions[1].state).to eq('PA')
    end
  end

  describe "#create_customer" do
    before do
      stub_post("/v2/customers").to_return(body: fixture('customer.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @customer = {
        :customer_id => '123',
        :exemption_type => 'wholesale',
        :name => 'Dunder Mifflin Paper Company',
        :exempt_regions => [
          {
            :country => 'US',
            :state => 'FL'
          },
          {
            :country => 'US',
            :state => 'PA'
          }
        ],
        :country => 'US',
        :state => 'PA',
        :zip => '18504',
        :city => 'Scranton',
        :street => '1725 Slough Avenue'
      }
    end

    it 'requests the right resource' do
      @client.create_customer(@customer)
      expect(a_post("/v2/customers")).to have_been_made
    end

    it 'returns the created customer' do
      customer = @client.create_customer(@customer)
      expect(customer.customer_id).to eq('123')
      expect(customer.exemption_type).to eq('wholesale')
      expect(customer.name).to eq('Dunder Mifflin Paper Company')
      expect(customer.country).to eq('US')
      expect(customer.state).to eq('PA')
      expect(customer.zip).to eq('18504')
      expect(customer.city).to eq('Scranton')
      expect(customer.street).to eq('1725 Slough Avenue')
    end

    it 'allows access to exempt_regions' do
      customer = @client.create_customer(@customer)
      expect(customer.exempt_regions[0].country).to eq('US')
      expect(customer.exempt_regions[0].state).to eq('FL')
      expect(customer.exempt_regions[1].country).to eq('US')
      expect(customer.exempt_regions[1].state).to eq('PA')
    end
  end

  describe "#update_customer" do
    before do
      @customer_id = 123
      stub_put("/v2/customers/#{@customer_id}").to_return(body: fixture('customer.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @customer = {
        :customer_id => '123',
        :exemption_type => 'wholesale',
        :name => 'Dunder Mifflin Paper Company',
        :exempt_regions => [
          {
            :country => 'US',
            :state => 'FL'
          },
          {
            :country => 'US',
            :state => 'PA'
          }
        ],
        :country => 'US',
        :state => 'PA',
        :zip => '18504',
        :city => 'Scranton',
        :street => '1725 Slough Avenue'
      }
    end

    it 'requests the right resource' do
      @client.update_customer(@customer)
      expect(a_put("/v2/customers/#{@customer_id}")).to have_been_made
    end

    it 'returns the updated customer' do
      customer = @client.update_customer(@customer)
      expect(customer.customer_id).to eq('123')
      expect(customer.exemption_type).to eq('wholesale')
      expect(customer.name).to eq('Dunder Mifflin Paper Company')
      expect(customer.country).to eq('US')
      expect(customer.state).to eq('PA')
      expect(customer.zip).to eq('18504')
      expect(customer.city).to eq('Scranton')
      expect(customer.street).to eq('1725 Slough Avenue')
    end

    it 'allows access to exempt_regions' do
      customer = @client.update_customer(@customer)
      expect(customer.exempt_regions[0].country).to eq('US')
      expect(customer.exempt_regions[0].state).to eq('FL')
      expect(customer.exempt_regions[1].country).to eq('US')
      expect(customer.exempt_regions[1].state).to eq('PA')
    end
  end

  describe "#delete_customer" do
    before do
        stub_delete('/v2/customers/123').to_return(body: fixture('customer.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.delete_customer('123')
      expect(a_delete('/v2/customers/123')).to have_been_made
    end

    it 'returns the deleted customer' do
      customer = @client.delete_customer('123')
      expect(customer.customer_id).to eq('123')
      expect(customer.exemption_type).to eq('wholesale')
      expect(customer.name).to eq('Dunder Mifflin Paper Company')
      expect(customer.country).to eq('US')
      expect(customer.state).to eq('PA')
      expect(customer.zip).to eq('18504')
      expect(customer.city).to eq('Scranton')
      expect(customer.street).to eq('1725 Slough Avenue')
    end

    it 'allows access to exempt_regions' do
      customer = @client.delete_customer('123')
      expect(customer.exempt_regions[0].country).to eq('US')
      expect(customer.exempt_regions[0].state).to eq('FL')
      expect(customer.exempt_regions[1].country).to eq('US')
      expect(customer.exempt_regions[1].state).to eq('PA')
    end
  end

end
