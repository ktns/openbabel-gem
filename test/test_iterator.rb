require 'test/unit'

$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.expand_path('../../ext', __FILE__)

require 'openbabel/iterator'
require 'openbabel'

class OBIteratorTest < Test::Unit::TestCase
  def test_obatom
    smi2mol = OBConversion.new
    smi2mol.set_in_format("smi")

    mol = OBMol.new
    smi2mol.read_string(mol, 'ClC(C)(C)C') # t-butyl chloride
    mol.add_hydrogens

    clatom = mol.get_atom(1)
    assert_equal(clatom, mol.get_atom(1))

    assert_equal(clatom.get_atomic_num, 17)

    assert_equal(clatom.each_bond.count, 1)
    assert(clatom.each_bond.all?{|b| b.kind_of?(OBBond)})

    assert_equal(clatom.each_nbr_atom.count, 1)
    clatom.each_nbr_atom do |a|
      assert(a.kind_of?(OBAtom))
      assert_equal(a.get_atomic_num, 6)
    end

    alpha = clatom.each_nbr_atom.first
    assert_equal(alpha.get_atomic_num, 6)
    assert_equal(alpha.each_nbr_atom.count, 4)
    alpha.each_nbr_atom do |a|
      if a.get_atomic_num == 6
        a.each_bond do |b|
          assert_equal(b.get_bond_order, 1)
          a2,_ = [b.get_begin_atom,
                  b.get_end_atom].reject{|a2|a2==a}
          assert(a.each_nbr_atom.any?{|a3|a3==a2})
        end
        a.each_nbr_atom do |a2|
          assert_equal(a2.each_bond.count, a2.each_nbr_atom.count)
          unless a2 == alpha
            assert_equal(a2.get_atomic_num, 1)
          end
        end
      else
        assert_equal(a, clatom)
      end
    end
  end
end
