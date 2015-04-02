module Vcloud
  module Launcher
    module Schema

      VAPP_NETWORK = {
        type: 'hash',
        internals: {
          name: {
            type: 'string',
            required: true,
          },
          description: {
            type: 'string',
            required: false,
          },
          parent_network: {
            type: 'string',
            required: false,
          },
          fence_mode: {
            type: 'enum',
            required: false,
            acceptable_values: %w{ iso isolated nat natRouted },
          },
          is_inherited: {
            type: 'boolean',
            required: false,
          },
          is_enabled: {
            type: 'boolean',
            required: false,
          },
          gateway: {
            type: 'ip_address',
            required: false,
          },
          netmask: {
            type: 'ip_address',
            required: false,
          },
          start_address: {
            type: 'ip_address',
            required: true,
          },
          end_address: {
            type: 'ip_address',
            required: true,
          },
        },
      }
    end
  end
end
