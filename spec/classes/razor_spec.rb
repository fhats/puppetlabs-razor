require 'spec_helper'

describe 'razor', :type => 'class' do

  context 'On an unknown OS' do
   let :facts do { :osfamily => "Unknown" } end
    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

  context 'On Ubuntu 12 something' do
   let :facts do { :osfamily               => "Debian",
                   :operatingsystem        => 'Ubuntu',
                   :operatingsystemrelease => '12.04',
                   :lsbdistcodename        => 'Lucid'
                  } end
  it { should contain_class 'razor::server' }
  end

end
