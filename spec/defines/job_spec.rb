require 'spec_helper'

describe 'syscron::job' do
  concat_basedir = '/var/lib/puppet/concat'

  context 'with default configuration' do
    let(:title) { 'somecron' }
    filename = 'somecron'
    content = "#!/bin/sh/\nls /"
    source = 'puppet:///cronjobs/somecron'

    context 'with hourly entry' do
      cron_event = 'hourly'
      cronpath = "/etc/cron.#{cron_event}/#{filename}"

      context 'with content defined and source undefined' do
        let(:params) { { :cron_event => cron_event, :filename => filename, :content => content } }
        let(:facts) { { :concat_basedir => concat_basedir } }

        it { should contain_file(cronpath).with(
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0755',
          'content' => content
        ).without_source }
      end

      context 'with source defined and content undefined' do
        let(:params) { { :cron_event => cron_event, :filename => filename, :source => source } }
        let(:facts) { { :concat_basedir => concat_basedir } }

        it { should contain_file(cronpath).with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
          'source' => source
        ).without_content }
      end

      context 'with both source and content defined' do
        let(:params) { { :cron_event => cron_event, :filename => filename, :source => source, :content => content, } }
        let(:facts) { { :concat_basedir => concat_basedir } }

        it 'Should raise an error about having both source and content set' do
          expect { should contain_file(cronpath) }.to raise_error(Puppet::Error)
        end
      end

      context 'with neither source or content defined' do
        let(:params) { { :cron_event => cron_event, :filename => filename, } }
        let(:facts) { { :concat_basedir => concat_basedir } }

        it 'Should raise an error about not having either source or content set' do
          expect { should contain_file(cronpath) }.to raise_error(Puppet::Error)
        end
      end
    end

    context 'with yearly entry' do
      cron_event = 'yearly'
      cronpath = "/etc/cron.#{cron_event}/#{filename}"

      let(:params) { { :cron_event => cron_event, :filename => filename, :content => content, } }
      let(:facts) { { :concat_basedir => concat_basedir } }

      it 'Should raise an error about an unknown syscron entry' do
        expect { should contain_file(cronpath) }.to raise_error(Puppet::Error)
      end
    end
  end
end

