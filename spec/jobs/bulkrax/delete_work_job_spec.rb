# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe DeleteWorkJob, type: :job do
    subject(:delete_work_job) { described_class.new }
    let(:entry) { FactoryBot.build(:bulkrax_entry) }
    let(:importer_run) { FactoryBot.build(:bulkrax_importer_run) }

    describe 'successful job object removed' do
      before do
        work = instance_double("Work")
        factory = instance_double("Bulkrax::ObjectFactory")
        expect(work).to receive(:delete).and_return true
        expect(factory).to receive(:find).and_return(work)
        expect(entry).to receive(:factory).and_return(factory)
      end

      it 'increments :deleted_records' do
        entry.save
        importer_run.save
        delete_work_job.perform(entry, importer_run)
        importer_run.reload
        expect(importer_run.enqueued_records).to equal(0)
        expect(importer_run.deleted_records).to equal(2)
      end
    end

    describe 'successful job object not found' do
      before do
        factory = instance_double("Bulkrax::ObjectFactory")
        expect(factory).to receive(:find).and_return(nil)
        expect(entry).to receive(:factory).and_return(factory)
      end

      it 'increments :deleted_records' do
        entry.save
        importer_run.save
        delete_work_job.perform(entry, importer_run)
        importer_run.reload
        expect(importer_run.enqueued_records).to equal(0)
        expect(importer_run.deleted_records).to equal(2)
      end
    end
  end
end
