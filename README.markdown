Hubble Gateway Blog
===================

This is the source code for the official blog of Hubble, the first trusted U.S.
gateway for the stellar network. You can find us online at
[hubblegateway.com](http://www.hubblegateway.com).

You can learn more about stellar on [stellar.org](http://stellar.org).

Installation
------------


First install external dependencies

```
brew install libxml2 libxslt
brew link libxml2 libxslt
```

Also requires ruby, rubygems, and bundler. If you don't have these, install them
before continuing.

Install needed gems with:
```
bundle install
```

Make sure everything works with:
```
rake preview
```

If there were no errors, it worked! (Warnings are okay)
You can visit the site at http://localhost:4000