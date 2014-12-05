Plex Autodelete
===

[![Gem Version](https://badge.fury.io/rb/plex-autodelete.svg)](http://badge.fury.io/rb/plex-autodelete)

Automatically delete files that have been marked as watched in Plex.

#### Install
```
gem install plex-autodelete
```

#### Configure
```
plex-autodelete install
```

#### Run
```
plex-autodelete cleanup
```

#### Example ~/.plex-autodelete.yml file
```
---
:host: 127.0.0.1
:port: 32400
:token: token123
:skip:
- Moomin (1990)
- Adventure Time
:delete: true
:section: 1
```
