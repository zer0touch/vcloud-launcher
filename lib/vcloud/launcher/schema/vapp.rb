module Vcloud
  module Launcher
    module Schema

      VAPP = {
        type: 'hash',
        required: true,
        allowed_empty: false,
        internals: {
          name:               { type: 'string', required: true, allowed_empty: false },
          vdc_name:           { type: 'string', required: true, allowed_empty: false },
          catalog:            { type: 'string', deprecated_by: 'catalog_name', allowed_empty: false },
          catalog_name:       { type: 'string', required: true, allowed_empty: false },
          catalog_item:       { type: 'string', deprecated_by: 'vapp_template_name', allowed_empty: false },
          vapp_template_name: { type: 'string', required: true, allowed_empty: false },
          vms:                { type: 'array', required: false, each_element_is: Vcloud::Launcher::Schema::VM },
          vapp_networks:      { type: 'array', required: false, each_element_is: Vcloud::Launcher::Schema::VAPP_NETWORK },
        },
      }

    end
  end
end
