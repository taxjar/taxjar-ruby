# TaxJar Ruby Gem [![RubyGems](http://img.shields.io/gem/v/taxjar-ruby.svg?style=flat-square)](https://rubygems.org/gems/taxjar-ruby) [![Build Status](http://img.shields.io/travis/taxjar/taxjar-ruby.svg?style=flat-square)](https://travis-ci.org/taxjar/taxjar-ruby)

<a href="http://developers.taxjar.com"><img src="http://www.taxjar.com/img/TJ_logo_color_office_png.png" alt="TaxJar" width="220"></a>

A Ruby interface to the TaxJar Sales Tax API. TaxJar makes sales tax filing easier for online sellers and merchants. 
See local jurisdictional tax reports, get payment reminders, and more. You can use our API to access TaxJar API endpoints, 
which can get information on sales tax rates, categories or upload transactions.

* This wrapper supports 100% of the [TaxJar API Version 2](http://developers.taxjar.com/api/#introduction)
* Data returned from API calls are mapped into Ruby objects

## Supported Ruby Versions

Ruby 1.9.3 or greater

## Gem Dependencies

Installing this gem also installs the following gems:

* [http](https://github.com/httprb/http.rb) Fast Ruby HTTP client with a chainable API and full streaming support.
* [addressable](https://github.com/sporkmonger/addressable) Replacement for the URI implementation that is part of Ruby's standard library. It more closely conforms to the relevant RFCs and adds support for IRIs and URI templates.
* [memoizable](https://github.com/dkubb/memoizable) Memoize method return values.
* [model_attribute](https://github.com/yammer/model_attribute) Type casted attributes for non-ActiveRecord models. [Forked](https://github.com/taxjar/model_attribute) to handle floats and more types.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'taxjar-ruby', require: 'taxjar'
```

And then execute:

```shell
$ bundle install
```

Or install it yourself as:

```shell
$ gem install taxjar-ruby
```

## Quick Start Guide

First, [get an API key from TaxJar](https://app.taxjar.com/api_sign_up/plus/). Copy and paste in your API key:

You are now ready to use TaxJar!

## Usage

### List all tax categories

#### Definition

```ruby
client.categories
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.categories
```

#### Example Response

```ruby
[
  #<Taxjar::Category:0x00000a @attrs={
    :name => 'Digital Goods', 
    :product_tax_code => 31000, 
    :description => 'Digital products transferred electronically.'
  }>, 
  #<Taxjar::Category:0x00000a @attrs={
    :name => 'Clothing', 
    :product_tax_code => 20010, 
    :description => 'All human wearing apparel suitable for general use'
  }>, 
  #<Taxjar::Category:0x00000a @attrs={
    :name => 'Non-Prescription',
    :product_tax_code => 51010, 
    :description => 'Drugs for human use without a prescription'
  }>
]
```

### List tax rates for a location (by zip/postal code)

#### Definition

```ruby
client.rates_for_location
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

# United States (ZIP+4)
rates = client.rates_for_location('90404-3370')

# United States (ZIP w/ Optional Params)
rates = client.rates_for_location('90404', {
  :city => 'SANTA MONICA',
  :country => 'US'
})

# International Examples (Requires City and Country)
rates = client.rates_for_location('V5K0A1', {
  :city => 'VANCOUVER',
  :country => 'CA'
})

rates = client.rates_for_location('00150', {
  :city => 'HELSINKI',
  :country => 'FI'
})
```

#### Example Response

```ruby
#<Taxjar::Rate:0x00000a @attrs={
  :zip => '90002', 
  :state => 'CA',
  :state_rate => 0.065,
  :county => 'LOS ANGELES',
  :county_rate => 0.01,
  :city => 'WATTS',
  :city_rate => 0,
  :combined_district_rate => 0.015,
  :combined_rate => 0.09,
  :freight_taxable => false
}>

#<Taxjar::Rate:0x00000a @attrs={
  :zip => 'V5K0A1',
  :city => 'Vancouver',
  :state => 'BC',
  :country => 'CA',
  :combined_rate => 0.12,
  :freight_taxable => true
}>

#<Taxjar::Rate:0x00000a @attrs={
  :country => 'FI',
  :name => 'Finland',
  :standard_rate => 0.24,
  :reduced_rate => nil,
  :super_reduced_rate => nil,
  :parking_rate => nil,
  :distance_sale_threshold => nil,
  :freight_taxable => true
}>
```

### Calculate Sales tax for an order

#### Definition

```ruby
client.tax_for_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.tax_for_order({
    :to_country => 'US',
    :to_zip => '90002',
    :to_city => 'Los Angeles',
    :to_state => 'CA',
    :from_country => 'US',
    :from_zip => '92093',
    :from_city => 'San Diego',                
    :amount => 15,
    :shipping => 1.5,
    :nexus_addresses => [{:address_id => 1,
                          :country => 'US',
                          :zip => '93101',
                          :state => 'CA',
                          :city => 'Santa Barbara',
                          :street => '1218 State St.'}],
    :line_items => [{:quantity => 1,
                     :unit_price => 15,
                     :product_tax_code => 20010}]
})
```

#### Example Response

```ruby
#<Taxjar::Tax:0x00000a @attrs={
  :order_total_amount => 16.5,
  :amount_to_collect => 1.35,
  :has_nexus => true,
  :freight_taxable => false,
  :tax_source => 'destination',
  :breakdown => #<Taxjar::Breakdown:0x00000a @attrs={
    :state_taxable_amount => 15,
    :state_tax_collectable => 0.98,
    :county_taxable_amount => 15,
    :county_tax_collectable => 0.15,
    :city_taxable_amount => 0,
    :city_tax_collectable => 0,
    :special_district_taxable_amount => 15,
    :special_district_tax_collectable => 0.22,
    :line_items => [
      #<Taxjar::BreakdownLineItem:0x00000a @attrs={
        :id => '1',
        :state_taxable_amount => 15,
        :state_sales_tax_rate => 0.065,
        :county_taxable_amount => 15,
        :county_tax_rate => 0.01,
        :city_taxable_amount => 0,
        :city_tax_rate => 0,
        :special_district_taxable_amount => 15,
        :special_tax_rate => 0.015
      }>
    ]
  }>
}>

#<Taxjar::Tax:0x00000a @attrs={
  :order_total_amount => 27.12,
  :shipping => 1.5,
  :taxable_amount => 27.12,
  :amount_to_collect => 5.42,
  :rate => 0.2,
  :has_nexus => true,
  :freight_taxable => true,
  :tax_source => 'origin'
}>
```

### List order transactions

#### Definition

```ruby
client.list_orders
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.list_orders({:from_transaction_date => '2014/01/01',
                    :to_transaction_date => '2015/05/30'})
```

#### Example Response

```ruby
['20', '21', '22']
```

### Show order transaction

#### Definition

```ruby
client.show_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.show_order('123')
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '123',
  :user_id => 11836,
  :transaction_date => '2015-05-14T00:00:00Z',
  :transaction_reference_id => nil,
  :from_country => 'US',
  :from_zip => 93107,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1281 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Create order transaction

#### Definition

```ruby
client.create_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

order = client.create_order({
    :transaction_id => '123',
    :transaction_date => '2015/05/14',
    :from_state => 'CA',
    :from_city => 'Santa Barbara',
    :from_street => '1218 State St',
    :from_country => 'US',
    :from_zip => '93101',
    :to_country => 'US',
    :to_state => 'CA',
    :to_city => 'Los Angeles',
    :to_street => '123 Palm Grove Ln',
    :to_zip => '90002',
    :amount => 16.5,
    :shipping => 1.5,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Fuzzy Widget',
                     :unit_price => 15,
                     :sales_tax => 0.95}]
})
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '20',
  :user_id => 11836,
  :transaction_date => '2015-05-14T00:00:00Z',
  :transaction_reference_id => nil,
  :from_country => 'US',
  :from_zip => 93101,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 16.5,
  :shipping => 1.5,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-9',
      :product_tax_code => nil,
      :description => 'Fuzzy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Update order transaction

#### Definition

```ruby
client.update_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

order = client.update_order({
    :transaction_id => '123',
    :amount => 17,
    :shipping => 2,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-0',
                     :description => 'Heavy Widget',
                     :unit_price => 15,
                     :discount => 0,
                     :sales_tax => 0.95}]
})
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '123',
  :user_id => 11836,
  :transaction_date => '2015-05-14T00:00:00Z',
  :transaction_reference_id => nil,
  :from_country => 'US',
  :from_zip => 93101,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Delete order transaction

#### Definition

```ruby
client.delete_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.delete_order('123')
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '123',
  :user_id => 11836,
  :transaction_date => '2015-05-14T00:00:00Z',
  :transaction_reference_id => nil,
  :from_country => 'US',
  :from_zip => 93101,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Listing refund transactions

#### Definition

```ruby
client.list_refunds
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.list_refunds({:from_transaction_date => '2014/01/01',
                     :to_transaction_date => '2015/05/30'})
```

#### Example Response

```ruby
['203', '204', '205']
```

### Show refund transaction

#### Definition

```ruby
client.show_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.show_refund('321')
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '321',
  :user_id => 11836,
  :transaction_date => '2015-06-14T00:00:00Z',
  :transaction_reference_id => 123,
  :from_country => 'US',
  :from_zip => 93107,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Create refund transaction

#### Definition

```ruby
client.create_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

refund = client.create_refund({
    :transaction_id => '321',
    :transaction_date => '2015/05/14',
    :transaction_reference_id => '123',
    :from_country => 'US',
    :from_zip => '93107',
    :from_state => 'CA',
    :from_city => 'Santa Barbara',
    :from_street => '1218 State St',
    :to_country => 'US',
    :to_zip => '90002',
    :to_state => 'CA',
    :to_city => 'Los Angeles',
    :to_street => '123 Palm Grove Ln',
    :amount => 16.5,
    :shipping => 1.5,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Fuzzy Widget',
                     :unit_price => 15,
                     :sales_tax => 0.95}]
})
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '321',
  :user_id => 11836,
  :transaction_date => '2015-06-14T00:00:00Z',
  :transaction_reference_id => '123',
  :from_country => 'US',
  :from_zip => 93107,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 16.5,
  :shipping => 1.5,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Update refund transaction

#### Definition

```ruby
client.update_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

refund = client.update_refund({
    :transaction_id => '321',
    :amount => 17,
    :shipping => 2,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Heavy Widget',
                     :unit_price => 15,
                     :sales_tax => 0.95}]
})
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '321',
  :user_id => 11836,
  :transaction_date => '2015-06-14T00:00:00Z',
  :transaction_reference_id => '123',
  :from_country => 'US',
  :from_zip => 93107,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17.95,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-9',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```

### Delete refund transaction

#### Definition

```ruby
client.delete_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.delete_refund('321')
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '321',
  :user_id => 11836,
  :transaction_date => '2015-06-14T00:00:00Z',
  :transaction_reference_id => '123',
  :from_country => 'US',
  :from_zip => 93107,
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => 90002,
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => 17.95,
  :shipping => 2,
  :sales_tax => 0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-9',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => 15,
      :discount => 0,
      :sales_tax => 0.95
    }
  ]
}>
```
### List nexus regions

#### Definition

```ruby
client.nexus_regions
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '9e0cd62a22f451701f29c3bde214')

nexus_regions = client.nexus_regions
```

#### Example Response

```ruby
[
  #<Taxjar::NexusRegion:0x00000a @attrs={
    :country_code => 'US',
    :country => 'United States',
    :region_code => 'CA',
    :region => 'California'
  }>,
  #<Taxjar::NexusRegion:0x00000a @attrs={
    :country_code => 'US',
    :country => 'United States',
    :region_code => 'NY',
    :region => 'New York'
  }>,
  #<Taxjar::NexusRegion:0x00000a @attrs={
    :country_code => 'US',
    :country => 'United States',
    :region_code => 'WA',
    :region => 'Washington'
  }>
]
```

### Validate a VAT number

#### Definition

```ruby
client.validate
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '9e0cd62a22f451701f29c3bde214')

validation = client.validate({
  :vat => 'FR40303265045'
})
```

#### Example Response

```ruby
#<Taxjar::Validation:0x00000a @attrs={
  :valid => true,
  :exists => true,
  :vies_available => true,
  :vies_response => {
    :country_code => 'FR',
    :vat_number => '40303265045',
    :request_date => '2016-02-10',
    :valid => true,
    :name => 'SA SODIMAS',
    :address => "11 RUE AMPERE\n26600 PONT DE L ISERE"
  }
}>
```

### Summarize tax rates for all regions

#### Definition

```ruby
client.summary_rates
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '9e0cd62a22f451701f29c3bde214')

summarized_rates = client.summary_rates
```

#### Example Response

```ruby
[
  #<Taxjar::SummaryRate:0x00000a @attrs={
    :country_code => 'US',
    :country => 'United States',
    :region_code => 'CA',
    :region => 'California',
    :minimum_rate => {
      :label => 'State Tax',
      :rate => 0.065
    },
    :average_rate => {
      :label => 'Tax',
      :rate => 0.0827
    }
  }>,
  #<Taxjar::SummaryRate:0x00000a @attrs={
    :country_code => 'CA',
    :country => 'Canada',
    :region_code => 'BC',
    :region => 'British Columbia',
    :minimum_rate => {
      :label => 'GST',
      :rate => 0.05
    },
    :average_rate => {
      :label => 'PST',
      :rate => 0.12
    }
  }>,
  #<Taxjar::SummaryRate:0x00000a @attrs={
    :country_code => 'UK',
    :country => 'United Kingdom',
    :region_code => nil,
    :region => nil,
    :minimum_rate => {
      :label => 'VAT',
      :rate => 0.2
    },
    :average_rate => {
      :label => 'VAT',
      :rate => 0.2
    }
  }>
]
```

### Custom Options

Pass a hash to any API method above for the following options:

#### Timeouts

Set request timeout in seconds:

```ruby
client.tax_for_order({ timeout: 30 })
```

## Tests

An RSpec test suite is available to ensure API functionality:

```shell
$ git clone git://github.com/taxjar/taxjar-ruby.git
$ bundle install
$ rspec
```

## More Information

More information can be found on the [TaxJar developer site](http://developers.taxjar.com).

## License

TaxJar is released under the [MIT License](https://github.com/taxjar/taxjar-ruby/blob/master/LICENSE.txt).

## Support

Bug reports and feature requests should be filed on the [GitHub issue tracking page](https://github.com/taxjar/taxjar-ruby/issues). 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request
