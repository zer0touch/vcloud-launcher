require 'spec_helper'

module Vcloud

  describe Vcloud::Template do

    before(:each) do
      @mock_fog_interface = double(:fog_interface)
      @test_config = {
        :catalog      => 'test_catalog',
        :catalog_item => 'test_template'
      }
    end

    it 'should raise a RuntimeError if there is no template' do
      @mock_fog_interface.stub(:template).and_return(nil)
      test_template = Template.new(@mock_fog_interface, @test_config)
      expect { test_template.id }.to raise_exception(RuntimeError, 'Could not find template vApp.')
    end

    it 'should return the id of the template' do
      test_id = 'vappTemplate-12345678-90ab-cdef-0123-4567890abcde'
      test_catalog_item_entity = {
        :href => "/#{test_id}"
      }
      @mock_fog_interface.stub(:template).and_return(test_catalog_item_entity)
      test_template = Template.new(@mock_fog_interface, @test_config)
      test_template.id.should == test_id
    end

    # we think this test and functionality should actually be in fog_interface
    # but implementing it here for now
    it 'should fail gracefully if id is not of expected form' do
      test_catalog_item_entity = {
        :href => 'unexpected_id' 
      }
      @mock_fog_interface.stub(:template).and_return(test_catalog_item_entity)
      test_template = Template.new(@mock_fog_interface, @test_config)
      expect { test_template.id }.to raise_exception(RuntimeError, 'Bogus template id unexpected_id')
    end

    it 'should fail gracefully if FogInterface::template does not return a hash' do
      test_catalog_item_entity = []
      @mock_fog_interface.stub(:template).and_return(test_catalog_item_entity)
      test_template = Template.new(@mock_fog_interface, @test_config)
      expect { test_template.id }.to raise_exception(RuntimeError, 'Could not retrieve a template entity from vCloud')
    end

  end

end
