require 'spec_helper'

describe 'syscron' do
  let(:title) { 'syscron.testing' }

  concat_basedir = '/var/lib/puppet/concat'

  describe 'all configurations' do
    let(:facts) { { :concat_basedir => concat_basedir } }
    it { should contain_class('syscron::config') }
  end

  describe 'with no configuration' do
    let(:facts) { { :concat_basedir => concat_basedir } }

    it 'should set up /etc/crontab as a concat resource' do
      should contain_concat('/etc/crontab').with(
        'owner' => 'root',
        'group' => 'root',
        'mode'  => '0644'
      )
    end

    it 'should contain a crontab-head concat fragment' do
      should contain_concat__fragment('crontab-head').with(
        'order'   => '10',
        'target'  => '/etc/crontab',
        'content' => "SHELL=/bin/bash\nPATH=/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/usr/bin\n"
      )
    end

    [ { :title     => 'hourly',
        :directory => '/etc/cron.hourly',
        :minute    => '17',
        :user      => 'root',
        :command   => "cd / && run-parts --report /etc/cron.hourly",
      }, {
        :title     => 'daily',
        :directory => '/etc/cron.daily',
        :minute    => '25',
        :hour      => '6',
        :user      => 'root',
        :command   => 'test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )',
      }, {
        :title     => 'weekly',
        :directory => '/etc/cron.weekly',
        :minute    => '47',
        :hour      => '6',
        :dayofweek => '7',
        :user      => 'root',
        :command   => 'test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )',
      }, {
        :title      => 'monthly',
        :directory  => '/etc/cron.monthly',
        :minute     => '52',
        :hour       => '6',
        :dayofmonth => '1',
        :user       => 'root',
        :command    => 'test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )',
      },
    ].each do |test|
      minute     = test[:minute]     ? test[:minute]     : '*'
      hour       = test[:hour]       ? test[:hour]       : '*'
      dayofmonth = test[:dayofmonth] ? test[:dayofmonth] : '*'
      month      = test[:month]      ? test[:month]      : '*'
      dayofweek  = test[:dayofweek]  ? test[:dayofweek]  : '*'

      it { should contain_syscron__config__entry(test[:title]).with(
        'minute'     => minute,
        'hour'       => hour,
        'dayofmonth' => dayofmonth,
        'month'      => month,
        'dayofweek'  => dayofweek,
        'user'       => test[:user],
        'command'    => test[:command]
      ) }

      it { should contain_file(test[:directory]).with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root'
      ) }

      it "should contain a #{test[:title]}-crontab-entry concat fragment" do
        should contain_concat__fragment("#{test[:title]}-crontab-entry").with(
          'order'   => '20',
          'target'  => '/etc/crontab',
          'content' => "#{minute} #{hour} #{dayofmonth} #{month} #{dayofweek} #{test[:user]} #{test[:command]}\n"
        )
      end
    end
  end
end
