require "rails_helper"
require "ar_pagination/offset_pagination/page"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/string"

describe "ArPagination::OffsetPagination::Page" do
  let!(:madeline) { Foo.create(name: 'Madeline', age: 125) }
  let!(:youngin) { Foo.create(name: "youngin'", age: 90) }
  let(:scope) { Foo.all }

  describe "#data" do

    it 'offsets the data' do
      page = ArPagination::OffsetPagination::Page.new(scope, {offset: 1})
      expect(page.data).to contain_exactly(youngin)
    end

    it 'limits the data' do
      page = ArPagination::OffsetPagination::Page.new(scope, {count: 1})
      expect(page.data).to contain_exactly(madeline)
    end

    it 'orders the data' do
      page = ArPagination::OffsetPagination::Page.new(scope, {sort: "-name"})
      expect(page.data.size).to eql(2)
      expect(page.data.first).to eql(youngin)
      expect(page.data.last).to eql(madeline)
    end
  end

  describe "#params_for" do
  end
end
