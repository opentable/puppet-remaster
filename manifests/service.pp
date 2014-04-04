# == Class remaster::service
#
# This class is meant to be called from remaster
# It ensure the service is running
#
class remaster::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource(service, 'puppet', {
    'ensure'     => 'running',
    'enable'     => true,
    'hasstatus'  => true,
    'hasrestart' => true
  })

}
