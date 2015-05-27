require "spec_helper"
require "ar_pagination/offset_pagination/page"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/string"

describe "Page" do
  let(:test_model1) { double("TestModel") }
  let(:offset) { double(:offset, limit: [test_model1]) }
  let(:scope) { double(:scope, offset: offset) }

  describe "#data" do

    it 'offsets the data' do
      expect(scope).to receive(:offset).with(2)

      page = OffsetPagination::Page.new(scope, {offset: 2})
      page.data
    end

    it 'limits the data' do
      expect(offset).to receive(:limit).with(10)

      page = OffsetPagination::Page.new(scope, {count: 10})
      page.data
    end

    it 'orders the data' do
      allow(scope).to receive(:order).and_return(scope)

      expect(scope).to receive(:order).with({name: :asc})

      page = OffsetPagination::Page.new(scope, {sort: "+name"})
      page.data
    end
  end

  describe "#params_for" do
  end
end
