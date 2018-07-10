
DeclareCategory( "IsGraphicSubgroupLattice", IsFrancyObject );

#############################################################################
##
#P  KnowsAllLevels . . . . . . . . . . . . . . . whether all levels are known
##
## FIXME...
DeclareFilter( "KnowsAllLevels" );

#############################################################################
##
##
## FIXME...
#F  HasHasseProperty . . . . . . . . . . . . . . .  whether lattice has Hasse
DeclareFilter( "HasseProperty" );

#############################################################################
##
#F  CanCompareSubgroups  . . . . . . . . . . whether we can compare subgroups
##
## FIXME...
DeclareFilter( "CanCompareSubgroups");

#############################################################################
##
#O  GraphicSubgroupLattice(<G>) . . . . displays subgroup lattice graphically
#O  GraphicSubgroupLattice(<G>,<def>)  . . . . . . . . . . same with defaults
##
##  Displays a graphic poset which shows (parts of) the subgroup lattice of
##  the group <group>. Normally only the whole group and the trivial group are
##  shown (behaviour of "InteractiveLattice" in xgap3). Returns a
##  IsGraphicSubgroupLattice object. Calls DecideSubgroupLatticeType. See
##  there for details.
##
if not IsBound(GraphicSubgroupLattice) then
  DeclareOperation( "GraphicSubgroupLattice", [ IsGroup ] );
  DeclareOperation( "GraphicSubgroupLattice", [ IsGroup, IsRecord ] );
fi;


#############################################################################
##
#O  DecideSubgroupLatticeType ( <grp> ) . decides about the type of a lattice
##
##  This operation is called while creation of a new graphic subgroup lattice.
##  It has to decide about the type of the lattice. That means it has to
##  decide 5 questions:
##   1) Are all levels known right from the beginning?
##   2) Has the lattice the HasseProperty?
##   3) Can we test two subgroups for equality reasonably cheaply?
##   4) Shall we create a vertex for the trivial subgroup at the beginning?
##   5) What menu operations are possible?
##   6) What information is displayed on RightClick?
##  Returns a list. The first four entries are boolean values for  questions
##  1-4. Note that if the answer to 2 is true, then the answer to 3 must also
##  be true. The fifth and sixth entry are configuration lists as explained 
##  in the configuration section of "ilatgrp.gi" for menu operations and
##  info displays respectively.
DeclareOperation( "DecideSubgroupLatticeType", [ IsGroup ] );
