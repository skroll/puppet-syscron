# == Define: syscron::job
#
# Represents a single job to be run in one of the syscron::config::entry
# entries.
#
# === Parameters
#
# [*cron_event*]
#  The name of the syscron::config::entry resource this cron job will
#  be placed in.
#
# [*filename*]
#  The output filename of the cron job that will be created in the entry
#  directory.
#
# [*content*]
#  The content of the cron job. If this is unset, than the source parameter
#  MUST be set.
#
# [*source*]
#  The source file of the cron job. If this is unset, than the content
#  parameter MUST be set.
#
# === Examples
#
#   syscron::job { 'ls_hourly':
#     cron_event => 'hourly',
#     filename => 'do_ls',
#     content => "#!/bin/bash\nls /",
#   }
#
# === Authors
#
# Scott Kroll <skroll@gmail.com>
#
# === Copyright
#
# Copyright 2012 Scott Kroll, unless otherwise noted.
# 
define syscron::job (
  $cron_event,
  $filename,
  $content = undef,
  $source = undef,
){
  include syscron

  $entry_path = $syscron::config::entries[$cron_event]['directory']

  if $entry_path == undef {
    fail("Unknown syscron entry '${cron_event}'!")
  }

  if $content == undef and $source == undef {
    fail('Either content or source must be set!')
  }

  if $content != undef and $source != undef {
    fail('Both content and source cannot be set!')
  }

  file { "${entry_path}/${filename}":
    ensure  => present,
    owner   => $syscron::config::owner,
    group   => $syscron::config::group,
    mode    => '0755',
    source  => $source,
    content => $content,
  }
}
