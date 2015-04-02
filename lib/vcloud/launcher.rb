require 'vcloud/core'

require 'vcloud/launcher/cli'
require 'vcloud/launcher/schema/vapp_network'
require 'vcloud/launcher/schema/vm'
require 'vcloud/launcher/schema/vapp'
require 'vcloud/launcher/schema/launcher_vapps'

require 'vcloud/launcher/launch'
require 'vcloud/launcher/preamble'
require 'vcloud/launcher/vm_orchestrator'
require 'vcloud/launcher/vapp_orchestrator'

require 'vcloud/launcher/version'

module Vcloud
  module Launcher

    def self.clone_object object
      Marshal.load(Marshal.dump(object))
    end

  end
end
