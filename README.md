[![Build Status](https://travis-ci.org/ut/ORTE-backend.svg?branch=master)](https://travis-ci.org/ut/ORTE-backend) [![Coverage Status](https://coveralls.io/repos/github/ut/ORTE-backend/badge.svg?branch=master)](https://coveralls.io/github/ut/ORTE-backend?branch=master) [![Maintainability](https://api.codeclimate.com/v1/badges/ab3d16e763664a942d72/maintainability)](https://codeclimate.com/github/ut/ORTE-backend/maintainability)

# ORTE-backend

Simple, straightforward backend for creating and managing places/POIs (or in german "Orte") and additional informations of a web-based map. Output is a public available API w/JSON.

Based on Ruby on Rails 5, Postgres, jQuery, Leaflet and Foundation 6.

This application is a its very beginning, work in progress. 

![preview](https://raw.githubusercontent.com/ut/ORTE-backend/master/app/assets/images/ORTE-backend-dev-002.jpg)

## Address and geolocation lookup

This application uses [Nominatim](https://nominatim.openstreetmap.org/), a search engine for OpenStreetMap data to look up address and geolocation data. By implementing this application you should respect the [Nominatim Usage Policy](https://operations.osmfoundation.org/policies/nominatim/)!

## Credits

Ulf Treger <ulf.treger@googlemail.com> with kind support by Pragma Shift Projects (code donation) and Treffentotal (acceptance testing and first use case with a map at [map.treffentotal.de](https://map.treffentotal.de), which gets its geolocations from OTRTE backend via JSON)

## Contributions

Please file bugs to our Github Repository at https://github.com/ut/ORTE-backend

## Licence

This project is licensed under a [GNU General Public Licence v3](https://github.com/ut/ORTE-backend/blob/master/LICENSE)
