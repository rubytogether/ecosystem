# The Ruby Ecosystem

We collect metrics from Bundler and rubygems.org and graph them.

## What metrics, exactly?

To start with, we will graph over time:

* Request counts for Ruby and Bundler, segregated by version.
* Request counts made from various platforms (eg. Linux, Windows etc)
* Request counts made from various CI providers (eg. CircleCI, Jenkins etc) 

## Why?

Apart from being interesting to look at, this information has the potential to help:

* Gem authors understand what versions of Ruby they should consider supporting
* Developers make decisions on if and when they should upgrade their Ruby version
* The Ruby community as a whole understand better how it is evolving and changing


## How does it work?

Running `bundle install` or `gem install` makes requests to rubygems.org to download various gems. These requests also send information to rubygems.org about the current Ruby and/or Bundler version being used, the platform being used and a few other things. This infomation is logged and stored in S3. Kirby (https://github.com/rubytogether/kirby) parses this info (there's a lot of it!) and aggregates it into JSON files. 

The Ecosystem app retrieves this JSON information on a daily basis and graphs it.


## Where is it?

Ecosystem is currently hosted on Heroku at: http://ecosystem.rubytogether.org

## WIP - Design

Here's what Brendan Miller (designer at Cloud City Development) has come up with so far. We are currently working on building this page out:

![Design 1](https://raw.githubusercontent.com/rubytogether/ecosystem/sidk/update-readme/readme_images/design.png)
