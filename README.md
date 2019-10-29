# TaxJar Sales Tax API for Ruby [![RubyGems](https://img.shields.io/gem/v/taxjar-ruby.svg?style=flat-square)](https://rubygems.org/gems/taxjar-ruby) [![Build Status](https://img.shields.io/travis/taxjar/taxjar-ruby.svg?style=flat-square)](https://travis-ci.org/taxjar/taxjar-ruby)

<a href="https://developers.taxjar.com"><img src="https://www.taxjar.com/img/TJ_logo_color_office_png.png" alt="TaxJar" width="220"></a>

A Ruby interface to the TaxJar [Sales Tax API](https://developers.taxjar.com/api/reference/?ruby). TaxJar makes sales tax filing easier for online sellers and merchants. See local jurisdictional tax reports, get payment reminders, and more. You can use our API to access TaxJar API endpoints, which can get information on sales tax rates, categories or upload transactions.

* This wrapper supports 100% of [SmartCalcs v2](https://developers.taxjar.com/api/#introduction)
* Data returned from API calls are mapped to Ruby objects

<hr>

[Supported Ruby Versions](#supported-ruby-versions)<br>
[Gem Dependencies](#gem-dependencies)<br>
[Installation](#installation)<br>
[Authentication](#authentication)<br>
[Usage](#usage)<br>
[Custom Options](#custom-options)<br>
[Sandbox Environment](#sandbox-environment)<br>
[Error Handling](#error-handling)<br>
[Tests](#tests)<br>
[More Information](#more-information)<br>
[License](#license)<br>
[Support](#support)<br>
[Contributing](#contributing)

<hr>

## Supported Ruby Versions

Ruby 2.0 or greater

## Gem Dependencies

Installing this gem also bundles the following dependencies:

* [http](https://github.com/httprb/http.rb) - Fast Ruby HTTP client with a chainable API and full streaming support.
* [addressable](https://github.com/sporkmonger/addressable) - Replacement for the URI implementation that is part of Ruby's standard library. It more closely conforms to the relevant RFCs and adds support for IRIs and URI templates.
* [memoizable](https://github.com/dkubb/memoizable) - Memoize method return values.
* [model_attribute](https://github.com/yammer/model_attribute) - Type casted attributes for non-ActiveRecord models.

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

## Authentication

[Generate an API token from TaxJar](https://app.taxjar.com/api_sign_up/). Copy and paste your API token when instantiating a new client:

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: 'YOUR_API_TOKEN')
```

You're now ready to use TaxJar! [Check out our quickstart guide](https://developers.taxjar.com/api/guides/ruby/#ruby-quickstart) to get up and running quickly.

## Usage

[`categories` - List all tax categories](#list-all-tax-categories-api-docs)<br>
[`tax_for_order` - Calculate sales tax for an order](#calculate-sales-tax-for-an-order-api-docs)<br>
[`list_orders` - List order transactions](#list-order-transactions-api-docs)<br>
[`show_order` - Show order transaction](#show-order-transaction-api-docs)<br>
[`create_order` - Create order transaction](#create-order-transaction-api-docs)<br>
[`update_order` - Update order transaction](#update-order-transaction-api-docs)<br>
[`delete_order` - Delete order transaction](#delete-order-transaction-api-docs)<br>
[`list_refunds` - List refund transactions](#list-refund-transactions-api-docs)<br>
[`show_refund` - Show refund transaction](#show-refund-transaction-api-docs)<br>
[`create_refund` - Create refund transaction](#create-refund-transaction-api-docs)<br>
[`update_refund` - Update refund transaction](#update-refund-transaction-api-docs)<br>
[`delete_refund` - Delete refund transaction](#delete-refund-transaction-api-docs)<br>
[`list_customers` - List customers](#list-customers-api-docs)<br>
[`show_customer` - Show customer](#show-customer-api-docs)<br>
[`create_customer` - Create customer](#create-customer-api-docs)<br>
[`update_customer` - Update customer](#update-customer-api-docs)<br>
[`delete_customer` - Delete customer](#delete-customer-api-docs)<br>
[`rates_for_location` - List tax rates for a location (by zip/postal code)](#list-tax-rates-for-a-location-by-zippostal-code-api-docs)<br>
[`nexus_regions` - List nexus regions](#list-nexus-regions-api-docs)<br>
[`validate_address` - Validate an address](#validate-an-address-api-docs)<br>
[`validate` - Validate a VAT number](#validate-a-vat-number-api-docs)<br>
[`summary_rates` - Summarize tax rates for all regions](#summarize-tax-rates-for-all-regions-api-docs)

<hr>


### List all tax categories <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-list-tax-categories))_</small>

> The TaxJar API provides product-level tax rules for a subset of product categories. These categories are to be used for products that are either exempt from sales tax in some jurisdictions or are taxed at reduced rates. You need not pass in a product tax code for sales tax calculations on product that is fully taxable. Simply leave that parameter out.

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

### Calculate sales tax for an order <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#post-calculate-sales-tax-for-an-order))_</small>

> Shows the sales tax that should be collected for a given order.

#### Definition

```ruby
client.tax_for_order
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.tax_for_order({
    :from_country => 'US',
    :from_zip => '94025',
    :from_state => 'CA',
    :from_city => 'Menlo Park',
    :from_street => '2825 Sand Hill Rd',
    :to_country => 'US',
    :to_zip => '94303',
    :to_state => 'CA',
    :to_city => 'Palo Alto',
    :to_street => '5230 Newell Road',
    :amount => 267.9,
    :shipping => 0,
    :nexus_addresses => [{:country => 'US',
                          :state => 'CA'}],
    :line_items => [{:id => '1',
                     :quantity => 1,
                     :product_tax_code => '19005',
                     :unit_price => 535.8,
                     :discount => 267.9}]
})
```

#### Example Response

```ruby
#<Taxjar::Tax:0x00000a @attrs={
  :taxable_amount => 0,
  :tax_source => 'destination',
  :shipping => 0,
  :rate => 0,
  :order_total_amount => 267.9
  :jurisdictions => #<Taxjar::Jurisdictions:0x00000a @attrs={
    :state => 'CA',
    :county => 'SAN MATEO',
    :country => 'US',
    :city => 'EAST PALO ALTO'
  }>,
  :has_nexus => true,
  :freight_taxable => false,
  :breakdown => #<Taxjar::Breakdown:0x00000a @attrs={
    :taxable_amount => 0,
    :tax_collectable => 0,
    :state_taxable_amount => 0,
    :state_tax_rate => 0,
    :state_tax_collectable => 0,
    :special_tax_rate => 0,
    :special_district_taxable_amount => 0,
    :special_district_tax_collectable => 0,
    :line_items => [
      #<Taxjar::BreakdownLineItem:0x00000a @attrs={
        :taxable_amount => 0,
        :tax_collectable => 0,
        :state_taxable_amount => 0,
        :state_sales_tax_rate => 0,
        :state_amount => 0,
        :special_tax_rate => 0,
        :special_district_taxable_amount => 0,
        :special_district_amount => 0,
        :id => '1',
        :county_taxable_amount => 0,
        :county_tax_rate => 0,
        :county_amount => 0,
        :combined_tax_rate => 0,
        :city_taxable_amount => 0,
        :city_tax_rate => 0,
        :city_amount => 0,
      }>
    ],
    :county_taxable_amount => 0,
    :county_tax_rate => 0,
    :county_tax_collectable => 0,
    :combined_tax_rate => 0,
    :city_taxable_amount => 0,
    :city_tax_rate => 0,
    :city_tax_collectable => 0
  }>
  :amount_to_collect => 0
}>
```

### List order transactions <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-list-order-transactions))_</small>

> Lists existing order transactions created through the API.

#### Definition

```ruby
client.list_orders
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.list_orders({:from_transaction_date => '2015/05/01',
                    :to_transaction_date => '2015/05/31'})
```

#### Example Response

```ruby
['20', '21', '22']
```

### Show order transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-show-an-order-transaction))_</small>

> Shows an existing order transaction created through the API.

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
  :from_zip => '93107',
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1281 State St',
  :to_country => 'US',
  :to_zip => '90002',
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

### Create order transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#post-create-an-order-transaction))_</small>

> Creates a new order transaction.

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
    :transaction_date => '2015/05/15',
    :from_country => 'US',
    :from_zip => '94025',
    :from_state => 'CA',
    :from_city => 'Menlo Park',
    :from_street => '2825 Sand Hill Rd',
    :to_country => 'US',
    :to_zip => '94303',
    :to_state => 'CA',
    :to_city => 'Palo Alto',
    :to_street => '5230 Newell Road',
    :amount => 267.9,
    :shipping => 0,
    :sales_tax => 0,
    :line_items => [{:id => '1',
                     :quantity => 1,
                     :description => 'Legal Services',
                     :product_tax_code => '19005',
                     :unit_price => 535.8,
                     :discount => 267.9,
                     :sales_tax => 0}]
})
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '123',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => '2015-05-15T00:00:00Z',
  :transaction_reference_id => nil,
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => 'US',
  :from_zip => '94025',
  :from_state => 'CA',
  :from_city => 'MENLO PARK',
  :from_street => '2825 Sand Hill Rd',
  :to_country => 'US',
  :to_zip => '94303',
  :to_state => 'CA',
  :to_city => 'PALO ALTO',
  :to_street => '5230 Newell Rd',
  :amount => 267.9,
  :shipping => 0,
  :sales_tax => 0,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => '19005',
      :description => 'Legal Services',
      :unit_price => 535.8,
      :discount => 267.9,
      :sales_tax => 0
    }
  ]
}>
```

### Update order transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#put-update-an-order-transaction))_</small>

> Updates an existing order transaction created through the API.

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
    :amount => 283.6,
    :shipping => 5,
    :sales_tax => 1.04,
    :line_items => [
      {
        :id => '1',
        :quantity => 1,
        :description => 'Legal Services',
        :product_tax_code => '19005',
        :unit_price => 535.8,
        :discount => 267.9,
        :sales_tax => 0
      },
      {
        :id => '2',
        :quantity => 2,
        :description => 'Hoberman Switch Pitch',
        :unit_price => 10.7,
        :discount => 10.7,
        :sales_tax => 1.04
      }
    ]
})
```

#### Example Response

```ruby
#<Taxjar::Order:0x00000a @attrs={
  :transaction_id => '123',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => '2015-05-15T00:00:00Z',
  :transaction_reference_id => nil,
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => 'US',
  :from_zip => '94025',
  :from_state => 'CA',
  :from_city => 'MENLO PARK',
  :from_street => '2825 Sand Hill Rd',
  :to_country => 'US',
  :to_zip => '94303',
  :to_state => 'CA',
  :to_city => 'PALO ALTO',
  :to_street => '5230 Newell Road',
  :amount => 283.6,
  :shipping => 5,
  :sales_tax => 1.04,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => '19005',
      :description => 'Legal Services',
      :unit_price => 535.8,
      :discount => 267.9,
      :sales_tax => 0
    },
    {
      :id => '2',
      :quantity => 2,
      :product_identifier => nil,
      :product_tax_code => nil,
      :description => 'Hoberman Switch Pitch',
      :unit_price => 10.7,
      :discount => 10.7,
      :sales_tax => 1.04
    }
  ]
}>
```

### Delete order transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#delete-delete-an-order-transaction))_</small>

> Deletes an existing order transaction created through the API.

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
  :provider => 'api',
  :transaction_date => nil,
  :transaction_reference_id => nil,
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => nil,
  :from_zip => nil,
  :from_state => nil,
  :from_city => nil,
  :from_street => nil,
  :to_country => nil,
  :to_zip => nil,
  :to_state => nil,
  :to_city => nil,
  :to_street => nil,
  :amount => nil,
  :shipping => nil,
  :sales_tax => nil,
  :line_items => []
}>
```

### List refund transactions <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-list-refund-transactions))_</small>

> Lists existing refund transactions created through the API.

#### Definition

```ruby
client.list_refunds
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.list_refunds({:from_transaction_date => '2015/05/01',
                     :to_transaction_date => '2015/05/31'})
```

#### Example Response

```ruby
['20-refund', '21-refund', '22-refund']
```

### Show refund transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-show-a-refund-transaction))_</small>

> Shows an existing refund transaction created through the API.

#### Definition

```ruby
client.show_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.show_refund('20-refund')
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '20-refund',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => '2015-05-15T00:00:00Z',
  :transaction_reference_id => '20',
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => 'US',
  :from_zip => '93107',
  :from_state => 'CA',
  :from_city => 'SANTA BARBARA',
  :from_street => '1218 State St',
  :to_country => 'US',
  :to_zip => '90002',
  :to_state => 'CA',
  :to_city => 'LOS ANGELES',
  :to_street => '123 Palm Grove Ln',
  :amount => -17,
  :shipping => -2,
  :sales_tax => -0.95,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => '12-34243-0',
      :product_tax_code => nil,
      :description => 'Heavy Widget',
      :unit_price => -15,
      :discount => 0,
      :sales_tax => -0.95
    }
  ]
}>
```

### Create refund transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#post-create-a-refund-transaction))_</small>

> Creates a new refund transaction.

#### Definition

```ruby
client.create_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

refund = client.create_refund({
    :transaction_id => '123-refund',
    :transaction_reference_id => '123',
    :transaction_date => '2015/05/15',
    :from_country => 'US',
    :from_zip => '94025',
    :from_state => 'CA',
    :from_city => 'Menlo Park',
    :from_street => '2825 Sand Hill Rd',
    :to_country => 'US',
    :to_zip => '94303',
    :to_state => 'CA',
    :to_city => 'Palo Alto',
    :to_street => '5230 Newell Road',
    :amount => -5.35,
    :shipping => -0,
    :sales_tax => -0.52,
    :line_items => [
      {
        :id => '1',
        :quantity => 1,
        :description => 'Legal Services',
        :product_tax_code => '19005',
        :unit_price => -0,
        :discount => -0,
        :sales_tax => -0
      },
      {
        :id => '2',
        :quantity => 1,
        :description => 'Hoberman Switch Pitch',
        :unit_price => -0,
        :discount => -5.35,
        :sales_tax => -0.52
      }
    ]
})
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '123-refund',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => '2015-05-15T00:00:00Z',
  :transaction_reference_id => '123',
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => 'US',
  :from_zip => '94025',
  :from_state => 'CA',
  :from_city => 'MENLO PARK',
  :from_street => '2825 Sand Hill Rd',
  :to_country => 'US',
  :to_zip => '94303',
  :to_state => 'CA',
  :to_city => 'PALO ALTO',
  :to_street => '5230 Newell Road',
  :amount => -5.35,
  :shipping => -0,
  :sales_tax => -0.52,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => '19005',
      :description => 'Legal Services',
      :unit_price => 0,
      :discount => 0,
      :sales_tax => 0
    },
    {
      :id => '2',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => nil,
      :description => 'Hoberman Switch Pitch',
      :unit_price => 0,
      :discount => -5.35,
      :sales_tax => -0.52
    }
  ]
}>
```

### Update refund transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#put-update-a-refund-transaction))_</small>

> Updates an existing refund transaction created through the API.

#### Definition

```ruby
client.update_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

refund = client.update_refund({
  :transaction_id => '123-refund',
  :transaction_reference_id => '123',
  :amount => -10.35,
  :shipping => -5
})
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '123-refund',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => '2015-05-15T00:00:00Z',
  :transaction_reference_id => '123',
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => 'US',
  :from_zip => '94025',
  :from_state => 'CA',
  :from_city => 'MENLO PARK',
  :from_street => '2825 Sand Hill Rd',
  :to_country => 'US',
  :to_zip => '94303',
  :to_state => 'CA',
  :to_city => 'PALO ALTO',
  :to_street => '5230 Newell Road',
  :amount => -10.35,
  :shipping => -5,
  :sales_tax => 0,
  :line_items => [
    {
      :id => '1',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => '19005',
      :description => 'Legal Services',
      :unit_price => 0,
      :discount => 0,
      :sales_tax => 0
    },
    {
      :id => '2',
      :quantity => 1,
      :product_identifier => nil,
      :product_tax_code => nil,
      :description => 'Hoberman Switch Pitch',
      :unit_price => 0,
      :discount => -5.35,
      :sales_tax => -0.52
    }
  ]
}>
```

### Delete refund transaction <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#delete-delete-a-refund-transaction))_</small>

> Deletes an existing refund transaction created through the API.

#### Definition

```ruby
client.delete_refund
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.delete_refund('123-refund')
```

#### Example Response

```ruby
#<Taxjar::Refund:0x00000a @attrs={
  :transaction_id => '123-refund',
  :user_id => 11836,
  :provider => 'api',
  :transaction_date => nil,
  :transaction_reference_id => nil,
  :customer_id => nil,
  :exemption_type => nil,
  :from_country => nil,
  :from_zip => nil,
  :from_state => nil,
  :from_city => nil,
  :from_street => nil,
  :to_country => nil,
  :to_zip => nil,
  :to_state => nil,
  :to_city => nil,
  :to_street => nil,
  :amount => nil,
  :shipping => nil,
  :sales_tax => nil,
  :line_items => []
}>
```

### List customers <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-list-customers))_</small>

> Lists existing customers created through the API.

#### Definition

```ruby
client.list_customers
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.list_customers
```

#### Example Response

```ruby
['123', '124', '125']
```

### Show customer <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-show-a-customer))_</small>

> Shows an existing customer created through the API.

#### Definition

```ruby
client.show_customer
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.show_customer('123')
```

#### Example Response

```ruby
#<Taxjar::Customer @attrs={
  :customer_id => "123",
  :exemption_type => "wholesale",
  :exempt_regions => [
    [0] {
      :country => "US",
      :state => "FL"
    },
    [1] {
      :country => "US",
      :state => "PA"
    }
  ],
  :name => "Dunder Mifflin Paper Company",
  :country => "US",
  :state => "PA",
  :zip => "18504",
  :city => "Scranton",
  :street => "1725 Slough Avenue"
}>
```

### Create customer <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#post-create-a-customer))_</small>

> Creates a new customer.

#### Definition

```ruby
client.create_customer
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

customer = client.create_customer({
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
})
```

#### Example Response

```ruby
#<Taxjar::Customer @attrs={
  :customer_id => "123",
  :exemption_type => "wholesale",
  :exempt_regions => [
    [0] {
      :country => "US",
      :state => "FL"
    },
    [1] {
      :country => "US",
      :state => "PA"
    }
  ],
  :name => "Dunder Mifflin Paper Company",
  :country => "US",
  :state => "PA",
  :zip => "18504",
  :city => "Scranton",
  :street => "1725 Slough Avenue"
}>
```

### Update customer <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#put-update-a-customer))_</small>

> Updates an existing customer created through the API.

#### Definition

```ruby
client.update_customer
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

customer = client.update_customer({
  :customer_id => '123',
  :exemption_type => 'wholesale',
  :name => 'Sterling Cooper',
  :exempt_regions => [
    {
      :country => 'US',
      :state => 'NY'
    }
  ],
  :country => 'US',
  :state => 'NY',
  :zip => '10010',
  :city => 'New York',
  :street => '405 Madison Ave'
})
```

#### Example Response

```ruby
#<Taxjar::Customer @attrs={
  :customer_id => "123",
  :exemption_type => "wholesale",
  :exempt_regions => [
    [0] {
      :country => "US",
      :state => "NY"
    }
  ],
  :name => "Sterling Cooper",
  :country => "US",
  :state => "NY",
  :zip => "10010",
  :city => "New York",
  :street => "405 Madison Ave"
}>
```

### Delete customer <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#delete-delete-a-customer))_</small>

> Deletes an existing customer created through the API.

#### Definition

```ruby
client.delete_customer
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '48ceecccc8af930bd02597aec0f84a78')

client.delete_customer('123')
```

#### Example Response

```ruby
#<Taxjar::Customer @attrs={
  :customer_id => "123",
  :exemption_type => "wholesale",
  :exempt_regions => [],
  :name => "Dunder Mifflin Paper Company",
  :country => "US",
  :state => "PA",
  :zip => "18504",
  :city => "Scranton",
  :street => "1725 Slough Avenue"
}>
```

### List tax rates for a location (by zip/postal code) <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-show-tax-rates-for-a-location))_</small>

> Shows the sales tax rates for a given location.
>
> **Please note this method only returns the full combined rate for a given location.** It does not support nexus determination, sourcing based on a ship from and ship to address, shipping taxability, product exemptions, customer exemptions, or sales tax holidays. We recommend using [`tax_for_order` to accurately calculate sales tax for an order](#calculate-sales-tax-for-an-order-api-docs).

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

### List nexus regions <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-list-nexus-regions))_</small>

> Lists existing nexus locations for a TaxJar account.

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

### Validate an address <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#post-validate-an-address))_</small>

> Validates a customer address and returns back a collection of address matches. **Address validation requires a [TaxJar Plus](https://www.taxjar.com/plus/) subscription.**

#### Definition

```ruby
client.validate_address
```

#### Example Request

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '9e0cd62a22f451701f29c3bde214')

addresses = client.validate_address({
  :country => 'US',
  :state => 'AZ',
  :zip => '85297',
  :city => 'Gilbert',
  :street => '3301 Greenfield Rd'
})
```

#### Example Response

```ruby
[
  #<Taxjar::Address:0x00000a @attrs={
    :zip => '85297-2176',
    :street => '3301 S Greenfield Rd',
    :state => 'AZ',
    :country => 'US',
    :city => 'Gilbert'
  }>
]
```

### Validate a VAT number <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-validate-a-vat-number))_</small>

> Validates an existing VAT identification number against [VIES](http://ec.europa.eu/taxation_customs/vies/).

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

### Summarize tax rates for all regions <small>_([API docs](https://developers.taxjar.com/api/reference/?ruby#get-summarize-tax-rates-for-all-regions))_</small>

> Retrieve minimum and average sales tax rates by region as a backup.
>
> This method is useful for periodically pulling down rates to use if the SmartCalcs API is unavailable. However, it does not support nexus determination, sourcing based on a ship from and ship to address, shipping taxability, product exemptions, customer exemptions, or sales tax holidays. We recommend using [`tax_for_order` to accurately calculate sales tax for an order](#calculate-sales-tax-for-an-order-api-docs).

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

## Custom Options

Pass a hash to any API method above for the following options:

#### Timeouts

Set request timeout in seconds:

```ruby
client.tax_for_order({ timeout: 30 })
```

## Sandbox Environment

You can easily configure the client to use the [TaxJar Sandbox](https://developers.taxjar.com/api/reference/?ruby#sandbox-environment):

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: 'YOUR_SANDBOX_API_TOKEN', api_url: 'https://api.sandbox.taxjar.com')
```

For testing specific [error response codes](https://developers.taxjar.com/api/reference/#errors), pass the custom `X-TJ-Expected-Response` header:

```ruby
client.set_api_config('headers', {
  'X-TJ-Expected-Response' => 422
})
```

## Error Handling

When invalid data is sent to TaxJar or we encounter an error, we’ll throw a `Taxjar::Error` with the HTTP status code and error message. To catch these exceptions, refer to the example below. [Click here](https://developers.taxjar.com/api/guides/ruby/#error-handling) for a list of common error response classes.

```ruby
require 'taxjar'
client = Taxjar::Client.new(api_key: '9e0cd62a22f451701f29c3bde214')

begin
  order = client.create_order({
    :transaction_date => '2015/05/14',
    :to_country => 'US',
    :to_state => 'CA',
    :to_zip => '90002',
    :amount => 17.45,
    :shipping => 1.5,
    :sales_tax => 0.95
  })
rescue Taxjar::Error => e
  # <Taxjar::Error::NotAcceptable: transaction_id is missing>
  puts e.class.name
  puts e.message
end
```

## Tests

An RSpec test suite is available to ensure API functionality:

```shell
$ git clone git://github.com/taxjar/taxjar-ruby.git
$ bundle install
$ rspec
```

## More Information

More information can be found on [TaxJar Developers](https://developers.taxjar.com).

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
