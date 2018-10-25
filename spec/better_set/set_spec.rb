module BetterSet
  RSpec.describe Set do
    describe ".big_union" do
      context "one of the args is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { Set.big_union(set, other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the union of all passed in sets" do
        set = Set.new([1])
        set2 = Set.new([1,2])
        set3 = Set.new(["a", "b"])

        expect(Set.big_union(set, set2, set3)).to eq(
          Set.new([1, 2, "a", "b"])
        )
      end
    end

    describe ".big_intersection" do
      context "one of the args is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { Set.big_intersection(set, other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the union of all passed in sets" do
        set = Set.new([1])
        set2 = Set.new([1,2])
        set3 = Set.new(["a", "b", 1])

        expect(Set.big_intersection(set, set2, set3)).to eq(
          Set.new([1])
        )
      end
    end

    describe "initialize" do
      context "no arguments" do
        it "initializes an empty set" do
          set = Set.new

          expect(set.instance_variable_get(:@hash)).to eq(Hash.new(false))
        end
      end

      context "argument is not an array" do
        it "raises an error" do
          expect { Set.new("hey") }.to raise_error(
            ArgumentError,
            "Argument must be Array class",
          )
        end
      end

      context "array of stuff" do
        it "creates and stores hash out of the array" do
          set = Set.new(["justine"])

          expect(set.instance_variable_get(:@hash)).to eq(
            "justine" => true,
          )
        end
      end

      context "duplicates" do
        it "does not store duplicates" do
          set = Set.new(["justine", "justine", 1, 1])

          expect(set.instance_variable_get(:@hash)).to eq(
            "justine" => true,
            1 => true,
          )
        end

        context "of type set" do
          it "does not store dupes" do
            expect(Set.new([Set.new, Set.new])).to eq(Set.new([Set.new]))
          end
        end
      end
    end

    describe "delegations" do
      it { should delegate_method(:all?).to(:to_a) }
      it { should delegate_method(:any?).to(:to_a) }
      it { should delegate_method(:none?).to(:to_a) }
      it { should delegate_method(:cartesian_product).to(:set_relations) }
      it { should delegate_method(:proper_subset?).to(:set_relations) }
      it { should delegate_method(:proper_superset?).to(:set_relations) }
      it { should delegate_method(:subset?).to(:set_relations) }
      it { should delegate_method(:superset?).to(:set_relations) }
      it { should delegate_method(:union).to(:set_relations) }
      it { should delegate_method(:intersection).to(:set_relations) }
      it { should delegate_method(:difference).to(:set_relations) }
      it { should delegate_method(:-).to(:set_relations) }
    end

    describe "#==" do
      context "other is not a set" do
        it "returns false" do
          set = Set.new
          other = "hey"

          expect(set == other).to be(false)
        end
      end

      context "self is a subset of other" do
        context "self is a superset of other" do
          it "returns true" do
            set = Set.new

            expect(set == set).to be(true)
          end

          context "self is not a superset of other" do
            it "returns false" do
              set = Set.new

              expect(set == Set.new(["justine"])).to be(false)
            end
          end
        end
      end

      context "self is a superset of other" do
        context "self is not a super set of other" do
          it "returns false" do
            set = Set.new

            expect(set == Set.new(["justine"])).to be(false)
          end
        end
      end

      context "self and other are disjoint" do
        it "returns false" do
          set = Set.new

          expect(set == Set.new(["justine"])).to be(false)
        end
      end
    end

    describe "#inspect" do
      context "empty set" do
        it "returns the correct representation" do
          set = Set.new

          expect(set.inspect).to eq("Ø")
        end
      end

      context "non empty" do
        it "returns the correct representation" do
          set = Set.new(["justine", 4, [1, "hey"], {foo: :bar}])

          expect(set.inspect).to eq('{"justine", 4, [1, "hey"], {:foo=>:bar}}')
        end
      end
    end

    describe "#to_s" do
      context "empty set" do
        it "returns the correct representation" do
          set = Set.new

          expect(set.to_s).to eq("Ø")
        end
      end

      context "non empty" do
        it "returns the correct representation" do
          set = Set.new(["justine", 4, [1, "hey"], {foo: :bar}])

          expect(set.to_s).to eq('{"justine", 4, [1, "hey"], {:foo=>:bar}}')
        end
      end
    end

    describe "#to_a" do
      it "returns an array of the elements in the set" do
        array = [1,2,3]
        second_array = [1,1,2,3]
        set = Set.new(array)
        other_set = Set.new(second_array)

        expect(set.to_a).to eq(array)
        expect(other_set.to_a).to eq(array)
      end
    end

    describe "#cardinality" do
      it "returns the length of the set" do
        array = [1,2,3]
        second_array = [1,1,2,3]
        set = Set.new(array)
        other_set = Set.new(second_array)

        expect(set.cardinality).to eq(3)
        expect(other_set.cardinality).to eq(3)
      end
    end

    describe "#member?" do
      context "set does not contain supplied element" do
        it "returns false" do
          set = Set.new([1,2,3])

          expect(set.member?(4)).to be(false)
        end
      end

      context "set contains supplied element" do
        it "returns true" do
          set = Set.new([1,2,3])

          expect(set.member?(2)).to be(true)
        end
      end
    end

    describe "#union" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.union(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements from both sets" do
        array = [1,2,3]
        array2 = ["hey", 3, Set.new]
        set = Set.new(array)
        set2 = Set.new(array2)

        expect(set.union(set2)).to eq(
          Set.new([1, 2, 3, "hey", Set.new])
        )
      end
    end

    describe "#intersection" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.intersection(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with only the elements in both sets" do
        array = [1,Set.new, 3]
        array2 = ["hey", 3, Set.new]
        set = Set.new(array)
        set2 = Set.new(array2)

        expect(set.intersection(set2)).to eq(
          Set.new([3, Set.new])
        )
      end
    end

    describe "#difference" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.difference(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements in self but not in other" do
        array = [1,Set.new, 3]
        array2 = ["hey", 3, Set.new]
        set = Set.new(array)
        set2 = Set.new(array2)

        expect(set.difference(set2)).to eq(
          Set.new([1])
        )
      end
    end

    describe "#-" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set - other }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements in self but not in other" do
        array = [1,Set.new, 3]
        array2 = ["hey", 3, Set.new]
        set = Set.new(array)
        set2 = Set.new(array2)

        expect(set - set2).to eq(
          Set.new([1])
        )
      end
    end

    describe "empty?" do
      context "it is empty" do
        it "returns false" do
          set = Set.new([1])

          expect(set.empty?).to be(false)
        end
      end

      context "it is empty" do
        it "returns false" do
          set = Set.new

          expect(set.empty?).to be(true)
        end
      end
    end

    describe "#powerset" do
      it "returns the set of all subsets of self" do
        set = Set.new
        set2 = Set.new([1,2])

        expect(set.powerset).to eq(Set.new([Set.new]))
        expect(set2.powerset).to eq(Set.new([
          Set.new,
          Set.new([1]),
          Set.new([2]),
          Set.new([1,2]),
        ]))
      end
    end

    describe "#cartesian_product" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.cartesian_product(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the cartesian product of two sets as a relation" do
        domain = Set.new([1,2])
        range = Set.new([3,4])
        ordered_pair = OrderedPair.new(1,3)
        ordered_pair2 = OrderedPair.new(1,4)
        ordered_pair3 = OrderedPair.new(2,3)
        ordered_pair4 = OrderedPair.new(2,4)
        ordered_pairs = Set.new([
          ordered_pair,
          ordered_pair2,
          ordered_pair3,
          ordered_pair4
        ])
        relation = Relation.new(ordered_pairs)

        expect(domain.cartesian_product(range)).to eq(relation)
      end
    end
  end
end
