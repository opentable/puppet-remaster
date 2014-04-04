####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with remaster](#setup)
    * [What remaster affects](#what-remaster-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with remaster](#beginning-with-remaster)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The remaster module for managing the transition of a puppet agent between masters

##Module Description

This module manages the server agent settings on a given puppet node. The intention of doing this is that it allows you to transition your node
from one puppet master to another during an upgrade process.

##Setup

###What remaster affects

* The server and ca_server settings in the /etc/puppet.conf file.

###Beginning with remaster

Assign a node to a particular master:

```puppet

   remaster { 'puppetmaster':
      puppetmaster => 'puppetmaster.corp.company.com'
   }
```
##Usage

###Classes and Defined Types

####Class: `remaster`
The remaster module primary type, `remaster`, guides the remastering of your nodes from one puppet master to another

**Parameters within `remaster`:**
#####`puppetmaster`
The fqdn of the master that you want your nodes to point to.

##Reference

###Classes
####Public Classes
* [`remaster`](#class-remaster): Remaster your node from one master to another
####Private Classes
* [`remaster::service`](#class-remasterservice): Ensure that the puppet service is up and running

##Limitations


##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.

###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker](https://github.com/puppetlabs/beaker) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
	BEAKER_DEBUG=yes bundle exec rspec spec/acceptance
