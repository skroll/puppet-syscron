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
