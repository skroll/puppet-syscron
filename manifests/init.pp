# == Class: syscron
#
# System level crontab support for a node.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'syscron': }
#
# === Authors
#
# Scott Kroll <skroll@gmail.com>
#
# === Copyright
#
# Copyright 2012 Scott Kroll, unless otherwise noted.
#
class syscron (
) {
  include concat::setup
  include syscron::config
}
