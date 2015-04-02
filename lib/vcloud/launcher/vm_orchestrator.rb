module Vcloud
  module Launcher
    class VmOrchestrator

      attr_reader :vm

      def initialize vcloud_vm, vapp
        vm_id = vcloud_vm[:href].split('/').last
        @vm = Core::Vm.new(vm_id, vapp)
      end

      def get_vm_name_from_config(vm_config)
        if vm_config[:name]
          vm_config[:name]
        else
          vm.vapp_name
        end
      end

      def customize(vm_config)
        vm_name = get_vm_name_from_config(vm_config)
        vm.update_name(vm_name)

        begin
          vm.configure_network_interfaces vm_config[:network_connections]
        rescue => e
          Vcloud::Core.logger.error(e.message)
        end

        vm.update_storage_profile(vm_config[:storage_profile]) if vm_config[:storage_profile]
        if vm_config[:hardware_config]
          vm.update_cpu_count(vm_config[:hardware_config][:cpu])
          vm.update_memory_size_in_mb(vm_config[:hardware_config][:memory])
        end
        vm.add_extra_disks(vm_config[:extra_disks])
        vm.update_metadata(vm_config[:metadata])

        if vm_config[:bootstrap] &&
           vm_config[:bootstrap].key?(:disabled) &&
           vm_config[:bootstrap][:disabled] == true
          Vcloud::Core.logger.debug("Not running guest customization script on #{vm_name}")
        else
          preamble = vm_config[:bootstrap] ? generate_preamble(vm_config) : ''
          Vcloud::Core.logger.debug("Running guest customization script on #{vm_name}")
          vm.configure_guest_customization_section(vm_name, preamble)
        end
      end

      private

      def generate_preamble(vm_config)
        preamble = ::Vcloud::Launcher::Preamble.new(vm.vapp_name, vm_config)
        preamble.generate
      end
    end
  end
end
