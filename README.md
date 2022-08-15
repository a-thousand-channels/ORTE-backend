![Release](https://badgen.net/github/release/a-thousand-channels/ORTE-backend) ![Last commit](https://badgen.net/github/last-commit/a-thousand-channels/ORTE-backend/main) ![Code Coverage w/SimpleCov](https://img.shields.io/badge/code_coverage-93%25-green) [![Linters + RSpec](https://github.com/a-thousand-channels/ORTE-backend/actions/workflows/rubyonrails-ci.yml/badge.svg)](https://github.com/a-thousand-channels/ORTE-backend/actions/workflows/rubyonrails-ci.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/ab3d16e763664a942d72/maintainability)](https://codeclimate.com/github/ut/ORTE-backend/maintainability)


# ORTE-backend

Backend application for creating and managing places/POIs (or in german "Orte") and additional informations on a web-based map. Output is a public available API w/JSON or exportable as CSV/JSON/GeoJSON data.

Based on Ruby on Rails 5, MySQL/MariaDB, jQuery, Leaflet and Foundation 6.

This application is work in progress. Contributions are welcome (see below).

<img src="https://raw.githubusercontent.com/ut/ORTE-backend/main/app/assets/images/ORTE-sample-map2-overview.jpg" style="max-width: 640px" width="640" />

## Address and geolocation lookup

This application uses [Nominatim](https://nominatim.openstreetmap.org/), a search engine for OpenStreetMap data to look up address and geolocation data. By implementing this application you should respect the [Nominatim Usage Policy](https://operations.osmfoundation.org/policies/nominatim/)!

## Map to go feature

ORTE Backend ist basically a backend which provides JSON and GeoJSON export of its layers and map. Since version 0.7 offers a "map to go" feature, where user can generate a static, Nuxt.js based website from their single layer (and its places) and place this site on their webspace.

## Installation

Basic steps for a local installation on your machine:

### Requirements

* Webserver (e.g. Apache or NGINX)
* Ruby 2.7+, RVM, Rubygems
* MySQL/Maria DB
* ffmpeg (for the video feature), ImageMagick (for the image feature)
* Redis

### Get repository

```bash
$ git clone git@github.com:a-thousand-channels/ORTE-backend.git
```
### Prepare Rails

```bash
$ gem install bundler
$ bundle install
```

### Setup MySQL/Maria DB

```bash
$ sudo mysql -u root
> CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
> GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
> CREATE DATABASE orte CHARACTER SET utf8 COLLATE utf8_general_ci;
> exit;
$ bundle exec rails db:schema:load
$ bundle exec rails db:seed
```

### Credentials + deployment

If you need custom credentials, e.g for a server installation, you can secre them with rails credentials and a master.key. Edit the credentials with

```bash
$ EDITOR=vim bundle exec rails credentials:edit
```

### Run locally

```bash
$ bundle exec rails s
```

### Test locally


```bash
$ RAILS_ENV=test bundle exec rails db:migrate
$ RAILS_ENV=test COVERAGE=true bundle exec rspec spec
```

## Credits

Project by A thousand channels, initiated by [Ulf Treger](https://github.com/ut) with kind support by and in collaboration with:

* [Pragma Shift](https://www.pragma-shift.net/), Hamburg, for initial code donation,
* Treffentotal 2018, Hamburg (first use public case with a map at [map.treffentotal.de](https://map.treffentotal.de), which gets its geolocations from ORTE backend via JSON),
* Participants of recent workshops of [city/data/explosion](https://citydataexplosion.tumblr.com/) at Kunst- und Kulturverein Spedition, Bremen,
* Members of the working group "Queer narratives, mappped" 💖 for acceptance testing, ideas and requests for improving the user interface and the maps.
* [Sandbostel Camp Memorial](https://www.stiftung-lager-sandbostel.de/) for the public submission interface and to [Sefux](https://github.com/Sefux) for coding it.

## Feedback & Contributions

Feedback, bug reports and code contributions are most welcome.

Send Feedback to hello@a-thousand-channels.xyz

Please file bug reports and feature request to our Github Repository at https://github.com/a-thousand-channels/ORTE-backend

For code contributions, please fork this repo, make a branch, commit your code & [create a pull request](https://help.github.com/en/articles/creating-a-pull-request).

All contributors shall respect the [Contributor Covenant Code of Conduct](https://github.com/a-thousand-channels/ORTE-backend/blob/main/CODE_OF_CONDUCT.md)


## Licence

This project is licensed under a [GNU General Public Licence v3](https://github.com/a-thousand-channels/ORTE-backend/blob/master/LICENSE)
