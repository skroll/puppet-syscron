define syscron::config::entry (
  $directory,
  $owner,
  $group,
  $minute,
  $hour,
  $dayofmonth,
  $month,
  $dayofweek,
  $user,
  $command
) {
  file {$directory:
    ensure => 'directory',
    owner => $owner,
    group => $group,
  }
}
