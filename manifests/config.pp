class syscron::config (
  $packages = ['cron']
  $owner    = 'root',
  $group    = 'root',
  $shell    = '/bin/bash',
  $path     = ['/usr/local/sbin', '/usr/local/bin', '/sbin', '/usr/sbin',
                '/usr/bin'],
  $entries = {
    'hourly'  => {
      directory  => '/etc/cron.hourly',
      minute     => 17,
      hour       => '*',
      dayofmonth => '*',
      month      => '*',
      dayofweek  => '*',
      user       => 'root',
      command    => 'cd / && run-parts --report /etc/cron.hourly',
    },
    'daily'   => {
      directory  => '/etc/cron.daily',
      minute     => 25,
      hour       => 6,
      dayofmonth => '*',
      month      => '*',
      dayofweek  => '*',
      user       => 'root',
      command    => "test -x /usr/sbin/anacron || ( cd / && run-parts \
--report /etc/cron.daily )",
    },
    'weekly'  => {
      directory  => '/etc/cron.weekly',
      minute     => 47,
      hour       => 6,
      dayofmonth => '*',
      month      => '*',
      dayofweek  => 7,
      user       => 'root',
      command    => "test -x /usr/sbin/anacron || ( cd / && run-parts \
--report /etc/cron.weekly )",
    },
    'monthly' => {
      directory  => '/etc/cron.monthly',
      minute     => 52,
      hour       => 6,
      dayofmonth => 1,
      month      => '*',
      dayofweek  => '*',
      user       => 'root',
      command    => "test -x /usr/sbin/anacron || ( cd / && run-parts \
--report /etc/cron.monthly )",
    },
  },
){
  create_resources(syscron::config::entry, $entries)

  concat { '/etc/crontab':
    owner => $owner,
    group => $group,
    mode  => '0644',
  }

  concat::fragment { 'crontab-head':
    order   => 10,
    target  => '/etc/crontab',
    content => template('syscron/syscron_head_block.erb'),
  }
}
