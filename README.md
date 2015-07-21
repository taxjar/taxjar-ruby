# TaxJar Ruby Gem

<a href="http://developers.taxjar.com"><img src="http://www.taxjar.com/img/TJ_logo_color_office_png.png" alt="TaxJar" width="220"></a>

A Ruby interface to the TaxJar API. TaxJar makes sales tax filing easier for online sellers and merchants. 
See local jurisdictional tax reports, get payment reminders, and more. You can use our API to access TaxJar API endpoints, 
which can get information on sales tax rates, categories or upload transactions.

* This wrapper supports 100% of the [TaxJar API Version 2](http://developers.taxjar.com/api/#introduction)
* Data returned from API calls are mapped into Ruby objects

## Supported Ruby Versions

Ruby 2.0 or greater

## Gem Dependencies

Installing this gem also installs the following gems:

* [http](https://github.com/httprb/http.rb) Fast Ruby HTTP client with a chainable API and full streaming support.
* [addressable](https://github.com/sporkmonger/addressable) Replacement for the URI implementation that is part of Ruby's standard library. It more closely conforms to the relevant RFCs and adds support for IRIs and URI templates.
* [memoizable](https://github.com/dkubb/memoizable) Memoize method return values.

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

```ruby

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
[#<Taxjar::Category:0x007f081dc3e278 @attrs={:name=>"Digital Goods", :product_tax_code=>31000, :description=>"Digital products transferred electronically, meaning obtained by the purchaser by means other than tangible storage media."}>, #<Taxjar::Category:0x007f081dc3de90 @attrs={:name=>"Clothing", :product_tax_code=>20010, :description=>" All human wearing apparel suitable for general use"}>, #<Taxjar::Category:0x007f081dc3da80 @attrs={:name=>"Non-Prescription", :product_tax_code=>51010, :description=>"Drugs for human use without a prescription"}>, #<Taxjar::Category:0x007f081dc3d670 @attrs={:name=>"Prescription", :product_tax_code=>51020, :description=>"Drugs for human use with a prescription"}>, #<Taxjar::Category:0x007f081dc3d288 @attrs={:name=>"Food & Groceries", :product_tax_code=>40030, :description=>"Food for humans consumption, unprepared"}>, #<Taxjar::Category:0x007f081dc3ce78 @attrs={:name=>"Other Exempt", :product_tax_code=>99999, :description=>"Item is exempt"}>, #<Taxjar::Category:0x007f081dc3ca90 @attrs={:name=>"Software as a Service", :product_tax_code=>30070, :description=>"Pre-written software, delivered electronically, but access remotely."}>]
```

### List tax rates for a location (by zip/postal code)

#### Definition
```ruby
client.rates_for_location
```
#### Example Request
```ruby
client.rates_for_location('10001')
```

#### Example Response
```ruby
#<Taxjar::Rate:0x007fc47056a928 @attrs={:zip=>90002, :state=>"CA", :state_rate=>0.065, :county=>"LOS ANGELES", :county_rate=>0.01, :city=>"WATTS", :city_rate=>0, :combined_district_rate=>0.015, :combined_rate=>0.09}>
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
    :amount => 16.50,
    :shipping => 1.5,
    :nexus_addresses => [{:address_id => 1,
                          :country => 'US',
                          :zip => '93101',
                          :state => 'CA',
                          :city => 'Santa Barbara',
                          :street => '1218 State St.'}],
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :unit_price => 15.0,
                     :product_tax_code => 31000}]
})
```
####Example Response
```ruby
#<Taxjar::Tax:0x007f3945688fc8 @attrs={:order_total_amount=>16.5, :amount_to_collect=>1.35, :has_nexus=>true, :freight_taxable=>false, :tax_source=>"destination", :breakdown=>{:state_taxable_amount=>15.0, :state_tax_collectable=>0.98, :county_taxable_amount=>15.0, :county_tax_collectable=>0.15, :city_taxable_amount=>0.0, :city_tax_collectable=>0.0, :special_district_taxable_amount=>15.0, :special_district_tax_collectable=>0.22, :line_items=>[{:id=>"1", :state_taxable_amount=>15.0, :state_sales_tax_rate=>0.065, :county_taxable_amount=>15.0, :county_tax_rate=>0.01, :city_taxable_amount=>0.0, :city_tax_rate=>0.0, :special_district_taxable_amount=>15.0, :special_tax_rate=>0.015}]}}>
```

### Create order transaction

```ruby
order = client.create_order({
    :transaction_id => '123',
    :transaction_date => '2015/05/14',
    :to_country => 'US',
    :to_zip => '90002',
    :to_state => 'CA',
    :to_city => 'Los Angeles',
    :to_street => '123 Palm Grove Ln',
    :amount => 17.45,
    :shipping => 1.5,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Fuzzy Widget',
                     :unit_price => 15.0,
                     :sales_tax => 0.95}]
})
```

### Update order transaction

```ruby
order = client.update_order({
    :transaction_id => '123',
    :amount => 17.95,
    :shipping => 2.0,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-0',
                     :description => 'Heavy Widget',
                     :unit_price => 15.0,
                     :discount => 0.0,
                     :sales_tax => 0.95}]
})
```

### Create refund transaction

```ruby
refund = client.create_refund({
    :transaction_id => '321',
    :transaction_date => '2015/05/14',
    :transaction_reference_id => '123',
    :to_country => 'US',
    :to_zip => '90002',
    :to_state => 'CA',
    :to_city => 'Los Angeles',
    :to_street => '123 Palm Grove Ln',
    :amount => 17.45,
    :shipping => 1.5,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Fuzzy Widget',
                     :unit_price => 15.0,
                     :sales_tax => 0.95}]
})
```

### Update refund transaction

```ruby
refund = client.update_refund{
    :transaction_id => '321',
    :amount => 17.95,
    :shipping => 2.0,
    :sales_tax => 0.95,
    :line_items => [{:quantity => 1,
                     :product_identifier => '12-34243-9',
                     :description => 'Heavy Widget',
                     :unit_price => 15.0,
                     :sales_tax => 0.95}]
})
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
