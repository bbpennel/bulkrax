# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bulkrax do
  describe '#mattr_accessor' do
    context 'default_work_type' do
      it 'responds to default_work_type' do
        expect(described_class).to respond_to(:default_work_type)
      end
      it 'default_work_type is settable' do
        expect(described_class).to respond_to(:default_work_type=)
      end
      it 'reads default work type from rails_helper' do
        expect(described_class.default_work_type).to eq('Work')
      end
    end

    context 'import_path' do
      after do
        described_class.import_path = 'tmp/imports'
      end

      it 'responds to import_path' do
        expect(described_class).to respond_to(:import_path)
      end

      it 'has a default import_path' do
        expect(described_class.import_path).to eq('tmp/imports')
      end

      it 'is settable' do
        described_class.import_path = 'other/import/path'

        expect(described_class).to respond_to(:import_path=)
        expect(described_class.import_path).to eq('other/import/path')
      end
    end

    context 'export_path' do
      after do
        described_class.export_path = 'tmp/exports'
      end

      it 'responds to export_path' do
        expect(described_class).to respond_to(:export_path)
      end

      it 'has a default export_path' do
        expect(described_class.export_path).to eq('tmp/exports')
      end

      it 'export_path is settable' do
        described_class.export_path = 'other/export/path'

        expect(described_class).to respond_to(:export_path=)
        expect(described_class.export_path).to eq('other/export/path')
      end
    end

    context 'parsers' do
      it 'has a default' do
        expect(described_class.parsers).to eq([
                                                { class_name: 'Bulkrax::OaiDcParser', name: 'OAI - Dublin Core', partial: 'oai_fields' },
                                                { class_name: 'Bulkrax::OaiQualifiedDcParser', name: 'OAI - Qualified Dublin Core', partial: 'oai_fields' },
                                                { class_name: 'Bulkrax::CsvParser', name: 'CSV - Comma Separated Values', partial: 'csv_fields' },
                                                { class_name: 'Bulkrax::BagitParser', name: 'Bagit', partial: 'bagit_fields' },
                                                { class_name: 'Bulkrax::XmlParser', name: 'XML', partial: 'xml_fields' }
                                              ])
      end

      it 'is settable' do
        expect(described_class).to respond_to(:parsers=)
      end
    end

    context 'server_name' do
      it 'has a default' do
        expect(described_class.server_name).to eq('bulkrax@example.com')
      end

      it 'is settable' do
        expect(described_class).to respond_to(:server_name=)
      end
    end

    context 'reserved_properties' do
      it 'has a default' do
        expect(described_class.reserved_properties).to eq(%w[
                                                            create_date
                                                            modified_date
                                                            date_modified
                                                            date_uploaded
                                                            depositor
                                                            arkivo_checksum
                                                            has_model
                                                            head
                                                            label
                                                            import_url
                                                            on_behalf_of
                                                            proxy_depositor
                                                            owner
                                                            state
                                                            tail
                                                            original_url
                                                            relative_path
                                                          ])
      end

      it 'is settable' do
        expect(described_class).to respond_to(:reserved_properties=)
      end
    end

    context 'default_field_mapping' do
      it 'has a default' do
        expect(described_class.default_field_mapping).to be_a(Proc)
      end

      it 'is responds with default hash' do
        expect(described_class.default_field_mapping.call('creator')).to eq("creator" => { excluded: false, from: ["creator"], if: nil, parsed: false, split: false })
      end
    end

    context 'field_mappings' do
      it 'has defaults' do
        expect(described_class.field_mappings.keys).to eq(['Bulkrax::OaiDcParser', 'Bulkrax::OaiQualifiedDcParser', 'Bulkrax::CsvParser', 'Bulkrax::BagitParser', 'Bulkrax::XmlParser'])
      end
    end
  end

  context 'api_definition' do
    it 'responds to api_definition' do
      expect(described_class).to respond_to(:api_definition)
    end
    it 'api_definition is notsettable' do
      expect(described_class).to respond_to(:api_definition=)
    end
    it 'loads the yaml file and returns a hash' do
      expect(described_class.api_definition).to be_a(Hash)
    end
  end

  context '.normalize_string' do
    it "returns a new string object" do
      given = "string"
      returned_value = described_class.normalize_string(given)
      expect(given.object_id).not_to eq(returned_value.object_id)
      expect(given).to eq(returned_value)
    end

    it "removes tricksy nasty hidden stringsy" do
      given = "\xEF\xBB\xBFfile"
      returned_value = described_class.normalize_string(given)
      expect(returned_value).to eq("file")
    end
  end
end
