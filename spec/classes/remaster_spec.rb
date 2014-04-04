require 'spec_helper'

describe 'remaster' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "when puppetmaster value set and differs from currently configured server on #{osfamily}" do
        let(:params) {{ 'puppetmaster' => 'puppetmaster-01.corp.company.com' }}
        let(:facts) {{
          :osfamily => osfamily,
          :servername   => 'puppetmaster.corp.company.com',
          :agent_ssldir => '/var/lib/puppet/ssl',
          :agent_config => '/etc/puppet/puppet.conf'
        }}

        it { should contain_ini_setting('update_main_server').with({
          'ensure'  => 'present',
          'section' => 'main',
          'setting' => 'server',
          'value'   => 'puppetmaster-01.corp.company.com',
          'path'    => '/etc/puppet/puppet.conf',
          'notify'  => 'Service[puppet]'
        }) }

        it { should contain_ini_setting('update_main_ca_server').with({
          'ensure'  => 'present',
          'section' => 'main',
          'setting' => 'ca_server',
          'value'   => 'puppetmaster-01.corp.company.com',
          'path'    => '/etc/puppet/puppet.conf'
        }) }

        it { should contain_ini_setting('remove_agent_server').with({
          'ensure'  => 'absent',
          'section' => 'agent',
          'setting' => 'server',
          'path'    => '/etc/puppet/puppet.conf'
        })}

        it { should contain_ini_setting('remove_agent_ca_server').with({
          'ensure'  => 'absent',
          'section' => 'agent',
          'setting' => 'ca_server',
          'path'    => '/etc/puppet/puppet.conf'
        })}

        it { should contain_file('/var/lib/puppet/ssl').with({
          'ensure' => 'absent',
          'force'  => 'true'
        }) }

        it { should contain_service('puppet').with({
          'ensure'  => 'running',
          'enable'  => 'true'
        })}
      end
    end
  end

  describe 'when puppetmaster value set and differs from currently configured server on Windows' do
    let(:params) {{ 'puppetmaster' => 'puppetmaster-01.corp.company.com' }}
    let(:facts) {{
      :osfamily => 'Windows',
      :servername   => 'puppetmaster.corp.company.com',
      :agent_ssldir => 'C:/ProgramData/PuppetLabs/puppet/etc/ssl',
      :agent_config => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf'
    }}

    it { should contain_ini_setting('update_main_server').with({
      'ensure'  => 'present',
      'section' => 'main',
      'setting' => 'server',
      'value'   => 'puppetmaster-01.corp.company.com',
      'path'    => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
      'notify'  => 'Service[puppet]'
    }) }

    it { should contain_ini_setting('update_main_ca_server').with({
      'ensure'  => 'present',
      'section' => 'main',
      'setting' => 'ca_server',
      'value'   => 'puppetmaster-01.corp.company.com',
      'path'    => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf'
    }) }

    it { should contain_ini_setting('remove_agent_server').with({
      'ensure'  => 'absent',
      'section' => 'agent',
      'setting' => 'server',
      'path'    => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf'
    })}

    it { should contain_ini_setting('remove_agent_ca_server').with({
      'ensure'  => 'absent',
      'section' => 'agent',
      'setting' => 'ca_server',
      'path'    => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf'
    })}

    it { should contain_file('C:/ProgramData/PuppetLabs/puppet/etc/ssl').with({
      'ensure' => 'absent',
      'force'  => 'true'
    }) }

    it { should contain_service('puppet').with({
      'ensure'  => 'running',
      'enable'  => 'true',
    })}
  end
end
