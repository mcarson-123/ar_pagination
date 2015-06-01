require "rails_helper"

describe "ArPagination::CursorPagination::Query" do
  let!(:youngin) { Foo.create(name: "youngin'", age: 90) }
  let!(:ancient) { Foo.create(name: "ancient'", age: 300) }
  let!(:madeline) { Foo.create(name: 'Madeline', age: 125) }
  let!(:really_old) { Foo.create(name: 'who knows', age: 500)}
  let(:scope) { Foo.all }

  describe "#fetch" do

    context "forward cursor" do
      context "with name as cursor key" do
        it "gets the correct data" do
          query = ArPagination::CursorPagination::Query.new(scope, :name)
          page = query.fetch(cursor: madeline.name)

          expect(page.data).to contain_exactly(madeline, really_old)
          expect(page.prev).to eql(ancient.name)
          expect(page.next).to eql(nil)
        end
      end

      context "with cursor as first index" do
        let(:query) { ArPagination::CursorPagination::Query.new(subscope) }
        let(:page) { query.fetch(cursor: subscope.first.id, count: 2) }

        context "for scope size less than elements remaining" do
          let(:subscope) { Foo.all }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(youngin, ancient)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(madeline.id)
          end
        end

        context "for scope size equal to elements remaining" do
          let(:subscope) { Foo.all.limit(2) }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(youngin, ancient)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end

        context "for scope size larger than elements remaining" do
          let(:subscope) { Foo.all.limit(1) }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(youngin)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end
      end

      context "with cursor as last index" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: Foo.all.last.id, count: count) }

        context "for count size equal to elements remaining" do
          let(:count) { 1 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(really_old)
            expect(page.prev).to eql(madeline.id)
            expect(page.next).to eql(nil)
          end
        end

        context "for count size larger than elements remaining" do
          let(:count) { 30 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(really_old)
            expect(page.prev).to eql(madeline.id)
            expect(page.next).to eql(nil)
          end
        end
      end

      context "with cursor as middle index" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: Foo.all.second.id, count: count) }


        context "for count size less than elements remaining" do
          let(:count) { 2 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(ancient, madeline)
            expect(page.prev).to eql(youngin.id)
            expect(page.next).to eql(really_old.id)
          end
        end

        context "for count size equal to elements remaining" do
          let(:count) { 3 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(ancient, madeline, really_old)
            expect(page.prev).to eql(youngin.id)
            expect(page.next).to eql(nil)
          end
        end

        context "for count size larger than elements remaining" do
          let(:count) { 30 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(ancient, madeline, really_old)
            expect(page.prev).to eql(youngin.id)
            expect(page.next).to eql(nil)
          end
        end
      end

      context "when sorting by age" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: cursor, sort: sort) }

        context "age ascending" do
          let(:sort) { "+age" }
          let(:cursor) { Foo.all.order({age: :asc}).first.id }

          it "gets the correct data" do
            expect(page.data).to eql([youngin, madeline, ancient, really_old])
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end

        context "age descending" do
          let(:sort) { "-age" }
          let(:cursor) { Foo.all.order({age: :desc}).first.id }

          it "gets the correct data" do
            expect(page.data).to eql([youngin, madeline, ancient, really_old].reverse!)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end
      end
    end

    context "backward cursor" do

      context "with name as cursor key" do
        it "gets the correct data" do
          query = ArPagination::CursorPagination::Query.new(scope, :name)
          page = query.fetch(cursor: ("-" + madeline.name))

          expect(page.data).to contain_exactly(youngin, ancient, madeline)
          expect(page.prev).to eql(nil)
          expect(page.next).to eql(really_old.name)
        end
      end

      context "with cursor as first index" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: -Foo.all.first.id, count: count) }

        context "for count size equal to elements remaining" do
          let(:count) { 1 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(Foo.second.id)
          end
        end

        context "for scope size larger than elements remaining" do
          let(:count) { 10 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(Foo.second.id)
          end
        end
      end

      context "with cursor as last index" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: -Foo.all.last.id, count: count) }

        context "for count size equal to elements remaining" do
          let(:count) { 1 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.last)
            expect(page.prev).to eql(Foo.third.id)
            expect(page.next).to eql(nil)
          end
        end

        context "for count size equal to elements remaining" do
          let(:count) { Foo.count }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first, Foo.second, Foo.third, Foo.last)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end

        context "for count size larger than elements remaining" do
          let(:count) { 30 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first, Foo.second, Foo.third, Foo.last)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(nil)
          end
        end
      end

      context "with cursor as middle index" do
        let(:query) { ArPagination::CursorPagination::Query.new(Foo.all) }
        let(:page) { query.fetch(cursor: -Foo.all.third.id, count: count) }


        context "for count size less than elements remaining" do
          let(:count) { 2 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.second, Foo.third)
            expect(page.prev).to eql(Foo.first.id)
            expect(page.next).to eql(Foo.last.id)
          end
        end

        context "for count size equal to elements remaining" do
          let(:count) { 3 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first, Foo.second, Foo.third)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(Foo.last.id)
          end
        end

        context "for count size larger than elements remaining" do
          let(:count) { 30 }

          it "gets the correct data" do
            expect(page.data).to contain_exactly(Foo.first, Foo.second, Foo.third)
            expect(page.prev).to eql(nil)
            expect(page.next).to eql(Foo.last.id)
          end
        end
      end

    end

  end
end
