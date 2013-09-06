require 'openbabel'
module OpenBabel
#OpenBabel::OBRingData
#[:next_ring]
#OpenBabel::OBResidue
#[:next_atom]
  class OBAtom
    module IteratorModule
      def each_bond
        return enum_for(:each_bond) unless block_given?
        iter = begin_bonds
        bond = begin_bond(iter)
        while bond
          yield bond
          bond = next_bond(iter)
        end
      end

      def each_nbr_atom
        return enum_for(:each_nbr_atom) unless block_given?
        iter = begin_bonds
        nbr  = begin_nbr_atom(iter)
        while nbr
          yield nbr
          nbr = next_nbr_atom(iter)
        end
      end
    end
    include IteratorModule
  end
#OpenBabel::OBMol
#[:next_conformer, :next_atom, :next_bond, :next_residue, :next_internal_coord]
#--
#OpenBabel::OBBitVec
#[:next_bit]
#--
#OpenBabel::OBRotorList
#[:next_rotor]
#--
#OpenBabel::OBMolAtomIter
#[:next_bond, :next_nbr_atom]
#OpenBabel::OBMolAtomDFSIter
#[:next_bond, :next_nbr_atom]
#OpenBabel::OBMolAtomBFSIter
#[:next_bond, :next_nbr_atom]
#--
#OpenBabel::OBAtomAtomIter
#[:next_bond, :next_nbr_atom]
#--
#OpenBabel::OBResidueIter
#[:next_atom]
#OpenBabel::OBResidueAtomIter
#[:next_bond, :next_nbr_atom]
end
