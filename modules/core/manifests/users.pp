class core::users inherits core::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  $hostname = $::hostname
  $is_vagrant = ::is_vagrant

  if ! defined(User['ehazlett']) {
    # user: ehazlett
    user { 'ehazlett':
      ensure      => present,
      comment     => 'Evan Hazlett',
      managehome  => true,
      shell       => '/bin/bash',
      groups      => ['sudo'],
      membership  => inclusive,
    }
    ssh_authorized_key { 'core::ehazlett_ssh_key':
      ensure    => present,
      type      => 'ssh-rsa',
      key       => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCy4nf8GOSklMF7vC9E3RNGBMZMCYqAFSz8r+NIhvX5zX7puNnBs6jAtywIjERRSnMVaqtlaqXGtHcCTcLMWkbo7sJIh/R3PyOGLwza7RB+HgAQST6waKZkXMt5+ggERTUJ/kY7CCVIdCBaFTCUeVOvCjWP/f07wrE/88CwTJ0RC53R4SoAbYdCsfryQ9Q7sMDhQpDLwJe0QqG7LoZyRPrRAPzurmg35Qzg+GaVoXE5CTNIh+kS4etTuSLs1LwCGdXPymBds8IgNJvsmRZkjYPh2GnFFShZkovNog3l9xLl2HmO0DRw3TXhDzXtE6tfFy1iyLH020t/ZHCi7QlTyNLt',
      user      => 'ehazlett',
    }
  }
  if ! defined(User['jbaker']) {
    # user: jbaker
    user { 'jbaker':
      ensure      => present,
      comment     => 'Jerry Baker',
      managehome  => true,
      shell       => '/bin/bash',
      groups      => ['sudo'],
      membership  => inclusive,
    }
    ssh_authorized_key { 'core::jbaker_ssh_key':
      ensure    => present,
      type      => 'ssh-rsa',
      key       => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9f+TN5uOBcTtjkmSn6B3Zs0FLr5xhXXX10FQt/5hEMTlLoPyUEmxkmVaCW6VI+64ACCq3QogvABEt+DffQJRPM3dC5cVIv5zIkiA+pX0lP9oiWXSCwy6i5tYNI+buyt3y99cEEoK/MAV+N87Wd5dUAlQon58x3wqM3Bgcgt0XLwLeiT3SeK/OCVxKud00mEGT1aYqysZosVwgbmFxFSmZYi5vObXDVy58gWUZx8l+q7dRgHcarh1Pos3HkDmm+BDsypWPpo+jZrw1XKPlBQ+YwUWofWPuUsDFrXQ/UTgE48tYT2rAjXeqimK5wZ0/lN0H4ZUN6LV2zpiAVJGgoBk/',
      user      => 'jbaker',
    }
  }
  if ! defined(User['kreynolds']) {
    # user: kreynolds
    user { 'kreynolds':
      ensure      => present,
      comment     => 'Kevin Reynolds',
      managehome  => true,
      shell       => '/bin/bash',
      groups      => ['sudo'],
      membership  => inclusive,
    }
    ssh_authorized_key { 'core::kreynolds_ssh_key':
      ensure    => present,
      type      => 'ssh-rsa',
      key       => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ+p1deBtmt8w2n1F5apiBlP3t/lSTlUSf5njnaOyn8o+DR+GLpsU/zgRLIyTx4eqcVOXti3RN0f35xTpAEOo/Y2Gx4otwnnT01cJ0b4syFN81D4Jo76BsTfmlNive//aLDf8hNgXiPiWIDmMaHtE9QEfcREq964z6JOxxPdNq2menR82ETNwjabT+o1vENyVcTWYBF6qj4hZ3akWRFiO3YP1vmTCzi785wbkuJGkA45NuYtjtVdyC9WoPSQ4Dz5qm7OLLIDsfBFZZlayDTB8P+Kbi3wMthfk4OzMb4jkXTLrFo86/BqUZJN55CU1rDeQc1/pB1WJdV7ytl4tW5RdF',
      user      => 'kreynolds',
    }
  }
}
