# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/modules/module_1/manifests/init.pp

# @summary Module 1: manages three file resources.
#
# This module demonstrates three common ways to deliver file content
# with Puppet: sourcing from the module's files directory, using a
# static file from the module, and providing inline content.
#
class module_1 {

  # Ensure the directory for module_1 managed files exists before
  # placing any files inside it.
  file { '/etc/module_1':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # file_a_hosts: manages /etc/hosts using a static file stored in
  # this module's files/ directory. The source URI puppet:///modules/
  # tells the agent to fetch the file from the Puppet server.
  file { 'file_a_hosts':
    path   => '/etc/hosts',
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/module_1/hosts',
  }

  # file_b_template: deploys b_template.txt from the module's files/
  # directory to a managed path on the node.
  file { 'file_b_template':
    path    => '/etc/module_1/b_template.txt',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/module_1/b_template.txt',
    require => File['/etc/module_1'],
  }

  # file_c_content: creates a file whose content is defined directly
  # in the manifest using the 'content' attribute (no external file needed).
  file { 'file_c_content':
    path    => '/etc/module_1/hello.txt',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "Hello Dave... go ahead, ask your Alexa to open the door...\n",
    require => File['/etc/module_1'],
  }

}
