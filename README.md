[![Gem Version](https://badge.fury.io/rb/pla.svg)](https://badge.fury.io/rb/pla)
[![Build Status](https://travis-ci.org/jspc/pla.svg?branch=master)](https://travis-ci.org/jspc/pla)

PLA
==

The PLA is the Port of London Authority. It handles ships and shipping into and around the Thames and stuff for London.

It provides ship movement details at it's [website](https://www.pla.co.uk/Port-Trade/Ship-movements/Ship-movements). Unfortunately the information it produces is just awful. There is no good way to handle the order in which comes (it appears to do some kind of ORDER BY on the vessel name field), for instance. Nor anyway to filter the data.

Thus I have written a scraper which will provide hashes of each entry.

This may be then used for filtering or searching or ordering as is fit.

Install
--

`gem install pla`

Usage
--

```ruby
require 'pla'

arrivals = PLA.arrivals
departures = PLA.departures
in_port = PLA.in-port
all = PLA.all

puts arrivals
puts departures
puts in_port
puts all

# Find next ten boats set to arrive
puts PLA.sort_arrivals_by_timestamp[0..9]

# List vessels alphabetically, as per PLA website
puts PLA.sort_all_by_vessel_name

# Find all movements made by Panamanian vessels
puts PLA.find_all_by_country 'Panama'

# Find all movements by a particular vessel
puts PLA.find_all_by_vessel_name 'feo swan'

# Listing the movements of a vessel by time
puts PLA.find_all_by_vessel_name('balmoral').sort_by{|s| s[:timestamp]}

# Find all vessels leaving a location
puts PLA.find_all_by_from('rotterdam')

# Likewise; all locations
puts PLA.find_all_by_location('rotterdam')
```

Licence
--

MIT
