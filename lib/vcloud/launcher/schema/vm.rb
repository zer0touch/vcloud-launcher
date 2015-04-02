module Vcloud
  module Launcher
    module Schema

      VM = {
        type: 'hash',
        required: false,
        allowed_empty: false,
        internals: {
          name: {
            type: 'string',
            required: false,
          },
          catalog_name: {
            type: 'string',
            required: false,
          },
          vapp_template_name: {
            type: 'string',
            required: false,
          },
          network_connections: {
            type: 'array',
            required: false,
            each_element_is: {
              type: 'hash',
              internals: {
                name: { type: 'string', required: true },
                ip_address: { type: 'ip_address', required: false },
                allocation_mode: { type: 'string', required: false },
              },
            },
          },
          storage_profile: { type: 'string', required: false },
          hardware_config: {
            type: 'hash',
            required: false,
            internals: {
              cpu: { type: 'string_or_number', required: false },
              memory: { type: 'string_or_number', required: false },
            },
          },
          extra_disks: {
            type: 'array',
            required: false,
            allowed_empty: false,
            each_element_is: {
              type: 'hash',
              internals: {
                name: { type: 'string', required: false },
                size: { type: 'string_or_number', required: false },
              },
            },
          },
          bootstrap: {
            type: 'hash',
            required: false,
            allowed_empty: false,
            internals: {
              script_path: { type: 'string', required: false },
              script_post_processor: { type: 'string', required: false },
              vars: { type: 'hash', required: false, allowed_empty: true },
              disabled: { type: 'boolean', required: false, allowed_empty: false },
            },
          },
          metadata: {
            type: 'hash',
            required: false,
            allowed_empty: true,
          },
        },
      }

    end
  end
end
