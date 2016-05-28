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

puts arrivals
puts departures

# Find next ten boats set to arrive
puts PLA.arrivals.sort_by{|a| a[:timestamp]}[0..9]

# Find all boats from Panama
puts PLA.arrivals.select{|b| b[:country] == 'Panama'}

```

Licence
--

MIT
