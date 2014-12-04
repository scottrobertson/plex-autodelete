Plex Autodelete
===

Automatically delete files that have been marked as watched in Plex.

#### Install
```
gem install plex-autodelete
```

*Until the author of ruby-plex tags a new release, you must install the git version manually:*
```
gem install specific_install
gem specific_install https://github.com/ekosz/Plex-Ruby
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
