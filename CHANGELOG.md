# Changelog
All notable changes to this project (since Version 0.3) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7] - 2022-03-03

With this release a map-to-go feature is introduced. With this, a user can preview and auto-generate a Nuxt/Vue-based Client from a map layer they created in the Orte Backend. The client can then be downloaded as a ZIP archive and published on a webspace.

### Added

- Map To Go: UI/Design #165
- Map To Go: Frontend interface #173
- Map To Go: Build library #170
- Map To Go: Metadata for client rendering #153
- Map To Go: Rake task #171
- Adding Preview link #203
- Allow basemap selection per dropdown #167

Plus some minor fixes and improvements

## [0.6] - 2022-01-18

### Added

- Friendly ID for maps and layers #44
- Photo gallery view #123
- A place should be annotated by quotes or comments #124
- Places: Make lat/lon coordinates editable #145
- Make popups visible on mouseover #133
- Cluster group: Design for a mix of places and annotations #134
- Creating new place: Show selected location in the background #139
- Cluster group at map level: Merge all entries of one place and cluster them #141
- Connect places of a layer #135 + Adding/editing relations (between places) (#144)
- Relations: Implement cubic beziers curves to layer maps, via Leaflet.curve (#144)
-  Adding relations + metdata to public json for layers and maps
- Make a place cloneable (with all associations) #146
- Set a map center and zoom level per layer (#159)
- Add carousel/orbit to place show view (#123)

### Fixes

- On some occasions the wrong map extent is shown #131
- Fix sorting of images (#87)

Etc

- Improved code coverage
- Github Actions with linting by Rubocop, checks by Brakemen and testing with Rspec

## [0.51] - 2021-05-08

Rails 5.2.6 + Ruby 2.7

### Added
- [Feature] Public submission interface (by @Sefux)
- [Feature] Internationalisation for the public interfaces w/Mobility (by @Sefux)

### Changed
- [Improvement] More flexible geo to address resolution, allows city only results


## [0.5] - 2021-03-05

### Added
- [Feature] Simple search within a map
- [UI] Custom iconset per map
- [UI] Tagging per place, tagcloud
- [Feature] Videoupload w/Active Storage + simple html5 player
- [App] Deployment setup w/Capistrano
- plus several smaller improvements and fixes

## [0.41] - 2020-10-11

### Added
- [Feature/MVC] Define a set of icons and connect it to a map, dispay it as map markers
- [Feature] Search for title/teaser/text of all places of one map
- [Images] Better display of metadata and infos
- [Images] Click on image shows large version in a modal
- [UI] Admin view: Combine access to settings, user, groups into one view
- [UI] Adding HTML titles + OG metadata for most views
- [UI] Some smaller improvements and adjustments
- [App] Improve RSpecs + feature tests

### Changed
- Finally removed old way of attaching images directly to places

## [0.40] - 2020-08-20

### Added
- [Place] Improve audio upload a bit
- [App] Adding CODE_OF_CONDUCT
- [App] Switching from masst to main branch

## [0.38] - 2020-07-26

### Added
- [Map] Adding leaflet control module (for user location on map)
- [MVC] Extend Layer and Map with a fulltext column
- [UI]  Sorting images of a place w/XHR
- [Place] Adding basic audio upload and play feature

### Changed
- [UI] Icons, switch from font to inline svg, set favicon

## [0.37] - 2020-05-01

### Added
- [UI] Custom icons for maps, layers, places w/SVG font
- [MVC] Image MVC, now more than one image can be attached to a place

### Changed
- [UI] Better handling of inplace layer change for places
- [UI] Some minor UI improvements

## [0.36] - 2020-04-10

### Changed
- [UI] Adjust some CSS positions, labels, styles
- [Fix] Fix error by resolving a city name
- [Fix] Some minor bugs

## [0.35] - 2020-03-28
### Added
- [UI/Map] Implementing markercluster + style it according to the SVG marker style
- [UI] List map titles A-Z
- [UI/Map] Introduce custom map extend, making it possible to switch from automatic bounds to manuelly set bounds
- [Feature] Export layer as CSV
- [Info] Public accesible help/infotext, adding contact email
- [Info] Basic installation description added

## [0.34] - 2020-01-26
### Added
- [UI] Popup: Nicer image display
- [UI] Improve views for smallscreens, make things like the forms more compact

## [0.33] - 2020-01-05
### Added
- Colored svg markers
- Rich text editor TinyMCE
- WorkSans as main typeface
- Better flow between address lookup and point'n'click on the map to set a new point
. Recenter/zoom map to extend of a places (getbounds())

### Fixed
- Fixed map overall marker display
- Fixed places edit: Only related layer are shown.
- Fixed minor UI things

## [0.32] - 2019-08-14
### Added
- Offer color alternatives for svg markers and selection via UI
- Introduce alternative layer display (places as text, places as images)

### Changed
- Minor UI improvements

## [0.31] - 2019-07-25
### Added
- Colored svg markers
- ColorGenerator Gem


## [0.3] - 2019-07-21
### Added
- More flexible timeformats and image uploads via active storage
