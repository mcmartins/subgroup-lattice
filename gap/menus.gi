BindGlobal( "MenuOpsForFiniteGroups",
        [ ]);
                                             
BindGlobal( "MenuOpsForFpGroups",
        [ ] );

BindGlobal( "InfoDisplaysForFiniteGroups",
        [ rec( name := "Size", attrib := Size ),
          rec( name := "Index", func := Index, parent := true ),
          rec( name := "IsAbelian", attrib := IsCommutative ),
          rec( name := "IsCentral", func := IsCentral, parent := true ),
          rec( name := "IsCyclic", attrib := IsCyclic ),
          rec( name := "IsNilpotent", attrib := IsNilpotentGroup ),
          rec( name := "IsNormal", func := IsNormal, parent := true ),
          rec( name := "IsPerfect", attrib := IsPerfectGroup ),
          rec( name := "IsSimple", attrib := IsSimpleGroup ),
          rec( name := "IsSolvable", attrib := IsSolvableGroup ),
          rec( name := "Isomorphism", attrib := IdGroup ),
        ] );
    
BindGlobal( "InfoDisplaysForFpGroups",
        [ rec( name := "Index", func := Index, parent := true ),
          rec( name := "IsNormal", func := IsNormal, parent := true ),
          rec( name := "IsFpGroup", func := IsFpGroup, parent := false ),
# FIXME: could that be of any help: (?)
#          rec( name := "IsSubgroupFpGroup", func := IsSubgroupFpGroup, 
#               parent := false ),
          #rec( name := "Abelian Invariants", attrib := AbelianInvariants,
          #     tostr := GGLStringAbInvs ),
          #rec( name := "CosetTable", attrib := CosetTableInWholeGroup,
         #      tostr := GGLStringCosetTable ),
         # rec( name := "IsomorphismFpGroup", func := IsomorphismFpGroup,
          #     parent := false, tostr := GGLStringEpimorphism ),
          #rec( name := "FactorGroup", func := GGLFactorGroup, parent := true,
          #     tostr := GGLStringGroup )
        ] );