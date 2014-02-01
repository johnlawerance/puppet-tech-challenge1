class puppet_challenge {
	# Packages
	package { 'git':
		ensure => installed,
	}	
	
	# File structures
	file { "/etc/puppet/hiera.yaml":
		ensure  => file,
		content => "# This configuration is being left blank per http://docs.puppetlabs.com/hiera/1/configuring.html else nginx will throw a warning on puppet execution.",	
	}

	vcsrepo { "/var/www/puppet-tech-challege.local":
		ensure => present,
		provider => git,
		source => 'https://github.com/puppetlabs/exercise-webpage.git',
		revision => 'master',
	}
	
	# Services
	class { 'nginx':}
	nginx::resource::vhost { 'puppet-tech-challenge.local':
		ensure      => present,
		www_root    => '/var/www/puppet-tech-challege.local',
		listen_port => 8080,
	}

	firewall { '8080: nginx':
		port   => 8080,
		proto  => tcp,
		action => accept,
	}
}

node 'puppet-tech-challenge' {
	include puppet_challenge
}
