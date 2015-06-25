# TaxJar Ruby

## Documentation

[TaxJar API Docs](http://developers.taxjar.com/api/)

## Examples


### HTTP gem

```
require "http"

taxjar_api_token = 'abc62a22f451701f29c3bde21g041125'

response = HTTP.headers(:accept => "application/json").auth("Bearer #{taxjar_api_token}").get("https://api.taxjar.com/v2/enhanced/rates/85040")

# Response body
{
  "rate":
  {
    "zip":"85040",
    "state":"AZ",
    "state_rate":"0.056",
    "county":"MARICOPA",
    "county_rate":"0.007",
    "city":"PHOENIX",
    "city_rate":"0.02",
    "combined_district_rate":"0.0",
    "combined_rate":"0.083"
  }
}
```

### HTTParty gem

```
require 'httparty'
  
response = HTTParty.get('https://api.taxjar.com/v2/enhanced/rates/85040', headers: {"Authorization" => "Bearer #{taxjar_api_token}"})

response = HTTParty.post('https://api.taxjar.com/v2/enhanced/taxes', headers: {"Authorization" => "Bearer #{taxjar_api_token}"},
  body: {
    amount: 19.95,
    shipping: 0,
    from_city: 'Murfreesboro',
    from_state: 'TN',
    from_zip: '37130',
    from_country: 'US',
    to_city: 'Kingston Springs',
    to_state: 'TN',
    to_zip: '37082',
    to_country: 'US',    
  })

# Response body
{
  "tax" => {
         "taxable_amount" => "19.95",
      "amount_to_collect" => 1.95,
                   "rate" => 0.0975,
              "has_nexus" => true,
        "freight_taxable" => true,
             "tax_source" => "origin",
              "breakdown" => {
                     "state_amount" => 1.4,
             "state_sales_tax_rate" => 0.07,
                    "county_amount" => 0.55,
                      "county_rate" => 0.0275,
                      "city_amount" => 0.0,
                    "city_tax_rate" => 0.0,
          "special_district_amount" => 0.0,
                 "special_tax_rate" => 0.0
      }
  }
}
```
