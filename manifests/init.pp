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

  # This just includes the configuration, so if users don't want to customize
  # it at all, than the majority of the work can be provided by just
  # including syscron::config.
  include syscron::config
}
