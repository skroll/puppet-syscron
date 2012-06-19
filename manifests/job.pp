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
