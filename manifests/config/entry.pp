# == Define: syscron::config::entry
#
# Represents a single "entry" in /etc/crontab.
#
# === Parameters
#
# [*directory*]
#  The directory that scripts will be placed in for this entry.
#
# [*minute*]
#  The minute when entries in this directory should be run. Use '*' for
#  every minute.
#
# [*hour*]
#  The hour when entries in this directory should be run. Use '*' for
#  every hour.
#
# [*dayofmonth*]
#  The day of month when entries in this directory should be run. Use '*' for
#  every day of the month.
#
# [*dayofweek*]
#  The day of week when entries in this directory should be run. Use '*' for
#  every day of the week.
#
# [*user*]
#  The use that entries in this directory should be run as.
#
# [*command*]
#  The command to execute to process entries in the directory.
#
# === Examples
#
#
# === Authors
#
# Scott Kroll <skroll@gmail.com>
#
# === Copyright
#
# Copyright 2012 Scott Kroll, unless otherwise noted.
# 
define syscron::config::entry (
  $directory,
  $minute,
  $hour,
  $dayofmonth,
  $month,
  $dayofweek,
  $user,
  $command
) {
  file { $directory:
    ensure => 'directory',
    owner  => $syscron::config::owner,
    group  => $syscron::config::group,
  }

  concat::fragment { "${name}-crontab-entry":
    order   => 20,
    target  => '/etc/crontab',
    content => template('syscron/syscron_entry_block.erb'),
  }
}
