module Vcloud
  module Launcher
    class VappOrchestrator

      def self.vm_name(vm_name, vapp_name)
        vm_name || vapp_name
      end

      def self.provision(vapp_config)
        vapp_name, vdc_name = vapp_config[:name], vapp_config[:vdc_name]

        vapp_config[:vapp_name] = vapp_name
        vapp_existing = Vcloud::Core::Vapp.get_by_name_and_vdc_name(vapp_name, vdc_name)

        template_name = vapp_config[:vapp_template_name] || vapp_config[:catalog_item]
        catalog_name = vapp_config[:catalog_name] || vapp_config[:catalog]
        template_id = Vcloud::Core::VappTemplate.get(template_name, catalog_name).id

        vm_configs = vapp_config[:vms]

        if vapp_existing
          Vcloud::Core.logger.info("Found existing vApp #{vapp_name} in vDC '#{vdc_name}'.")
          vapp = vapp_existing
        else
          first_vm_config = vm_configs.first
          vm_networks = extract_vm_network_connections(vapp_config)
          vapp_networks = extract_vapp_networks(vapp_config)
          vapp = Vcloud::Core::Vapp.instantiate(vapp_name, template_id,
                                                vdc_name, vm_networks,
                                                vapp_networks)
          Vcloud::Launcher::VmOrchestrator.new(vapp.vms.first, vapp).customize(first_vm_config)
          vm_configs.shift
          return vapp if vm_configs.empty?
        end

        vm_configs.each do |vm_config|
          begin
            template_name = vm_config[:vapp_template_name] || vm_config[:catalog_item]
            vm_catalog_name = vm_config[:catalog_name] || vm_config[:catalog]
            catalog_name = vm_catalog_name || catalog_name
            if template_name
              template_href = Vcloud::Core::VappTemplate.get(template_name, catalog_name).vm_href
              vm_config[:href] = template_href
            end
            vapp.recompose(vapp_name, vdc_name, vm_config,
                           extract_vm_network_connections(vapp_config),
                           extract_vapp_networks(vapp_config))
          rescue => e
            Vcloud::Core.logger.info(e.message)
          ensure
            # FIXME: only apply config if vm_config has not been applied
            ensure_vm_config(vapp, vm_config, vapp_name)
          end
        end

        vapp
      end

      def self.ensure_vm_config(vapp, vm_config, vapp_name)
        vm = vapp.vms.select do |remote_vm|
          remote_vm[:name] == (vm_config[:name] || vapp_name)
        end.first
        Vcloud::Core.logger.info("Applying config to VM #{vm[:name]}.") if vm
        Vcloud::Launcher::VmOrchestrator.new(vm, vapp).customize(vm_config) if vm
      end

      def self.get_vm_by_name(vapp, config)
        vapp.vms.select { |vm| vm[:name] == config[:name] }.first
      end

      def self.extract_vapp_networks(vapp_config)
        return [] unless vapp_config[:vapp_networks]
        return vapp_config[:vapp_networks]
      end

      def self.extract_vm_network_connections(vapp_config)
        return [] unless vapp_config[:vms]
        vapp_config[:vms].collect do |conf|
          next unless conf[:network_connections]
          conf[:network_connections].collect { |c| c[:name] }
        end.flatten.uniq
      end

    end
  end
end
