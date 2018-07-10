#############################################################################
##
#M  GraphicSubgroupLattice(<G>) . . . . displays subgroup lattice graphically
#M  GraphicSubgroupLattice(<G>,<def>)  . . . . . . . . . . same with defaults
##
##  Displays a graphic poset which shows (parts of) the subgroup lattice of
##  the group <group>. Normally only the whole group and the trivial group are
##  shown (behaviour of "InteractiveLattice" in xgap3). Returns a
##  IsGraphicSubgroupLattice object. Calls DecideSubgroupLatticeType. See
##  there for details.
##
InstallMethod( GraphicSubgroupLattice,
    "for a group, and a record",
    true,
    [ IsGroup, IsRecord ],
    0,
function(G, def)
  local latticetype, graph, poset, l, str, vmath, v2, v1;
  
  latticetype := DecideSubgroupLatticeType(G);
  # we do some heuristics to avoid the trivial group:
  # if we know all levels, we probably can calc. Size, if we shall generate
  # a vertex for the trivial subgroup, we should also know Size!
  if latticetype[1] or latticetype[4] then   
    # no trivial case:
    if Size(G) = 1 then
      return Error( "<G> must be non-trivial" );
    fi;
  fi;

  # create a new canvas
  poset := Canvas("GraphicSubgroupLattice");
  # and make it a GraphicSubgroupLattice
  SetFilterObj( poset, IsGraphicSubgroupLattice );

  if HasName(G) then
    SetTitle(poset, Concatenation(Title(poset)," of ",Name(G)));
  elif HasIdGroup(G) then
    SetTitle(poset, Concatenation(Title(poset)," of ",String(IdGroup(G))));
  fi;

  if IsBound(def.width) then SetWidth(poset, def.width); fi;
  if IsBound(def.height) then SetHeight(poset, def.height); fi;
  if IsBound(def.title) then SetTitle(poset, def.title); fi;
  
  #poset!.group := G;
  
  # now the other filters, depending on type:
  if latticetype[1] then
    SetFilterObj(poset,KnowsAllLevels);
  fi;
  if latticetype[2] then
    SetFilterObj(poset,HasseProperty);
  fi;
  if latticetype[3] then
    SetFilterObj(poset,CanCompareSubgroups);
  fi;
  
  # initialize some components:
  #poset!.selector := false;

  # set the limits:
  #poset!.limits := rec(conjugates := 100);
  
  if KnowsAllLevels(poset) then
    # We know how many levels so we can show the user
    Add(poset, FrancyMessage(FrancyMessageType.INFO, Concatenation("There are ", String(Length(DivisorsInt(Size(G)))), " levels in this Group.")));
  else
    # We don't know how many levels so we try to comput them
    if latticetype[4] then
      if CanComputeSize(G) and Size(G) <> infinity then
        Add(poset, FrancyMessage(FrancyMessageType.INFO, Concatenation("There are ", String(Size(G)), " levels in this Group.")));
      else
        Add(poset, FrancyMessage(FrancyMessageType.INFO, "We don't know how many levels there are on this group."));
      fi;
    fi;
  fi;
  
  # create an undirected graph to represent the poset
  # by adding layers later, the undirected graph turns into an Hasse diagram
  graph := Graph(GraphType.UNDIRECTED); Add(poset, graph);
  
  # create one or two initial vertices (G itself and trivial subgroup):
  # we seperate the mathematical data and the graphical data:
  vmath := rec(group := G, info := rec(Index := 1, IsNormal := true));
  vmath.class := [vmath];
  v2 := Shape(ShapeType.DIAMOND, "G");
  SetLayer(v2, 1);
  #v2!.vmath := vmath;
  #poset!.WholeGroupVert := v2;
  
  # we keep track of largest label:
  #poset!.largestlabel := 1;
  # we keep track of largest number of infinity label
  #poset!.largestinflevel := 0;
  
  Add(graph, v2);
  
  if latticetype[4] then
    vmath := rec(group := TrivialSubgroup(G));
    if CanComputeSize(G) then
      vmath.info := rec(Index := Size(G));
    else
      vmath.info := rec();
    fi;
    vmath.class := [vmath];
    if CanComputeSize(G) and Size(G) <> infinity then
      v1 := Shape(ShapeType.DIAMOND, "1");
      SetLayer(v1, vmath.info.Index);
    else
      v1 := Shape(ShapeType.DIAMOND, "1");
      SetLayer(v1, -1);
    fi;
    Add(graph, v1);
    
    # connect the two vertices
    Add(graph, Link(v1,v2));
    #poset!.TrivialGroupVert := v1;
  else
    #poset!.TrivialGroupVert := false;
  fi;
  
  # <G> is selected at first
  v2!.selected := true;
  
  # create menus:
  #GGLMakeSubgroupsMenu(poset,latticetype[5]);
  #poset!.menuoperations := latticetype[5];
  
  # Install the info method:
  #poset!.infodisplays := latticetype[6];
  #InstallPopup(poset,GGLRightClickPopup);
  
  # no vertex is green right now:
  poset!.lastresult := [];
         
  return poset;
end);

##
## without defaults record:
##
InstallOtherMethod(GraphicSubgroupLattice,
    "for a group",
    true,
    [ IsGroup ],
    0,
function(G)
  return GraphicSubgroupLattice(G,rec());
end);

#############################################################################
##
##  Decision function for subgroup lattice type:
##
#############################################################################


#############################################################################
##
#M  DecideSubgroupLatticeType(<grp>)  . . decides about the type of a lattice
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
##
##  The following is the default "fallback" method suitable for reasonably
##  small finite groups.
##
InstallMethod( DecideSubgroupLatticeType,
    "for a group",
    true,
    [ IsGroup ],
    0,
function( G )
  local knowslevels;
  if Size(G) > 10^17 then # that is just heuristic!
    knowslevels := false;
  else
    knowslevels := Length(DivisorsInt(Size(G))) < 50;
  fi;
  return [knowslevels,
          true,         # we assume HasseProperty
          true,         # we assume we can compare groups
          true,         # we want the trivial subgroup
          MenuOpsForFiniteGroups,
          InfoDisplaysForFiniteGroups];
end);

## for finitely presented groups:
InstallMethod( DecideSubgroupLatticeType,
    "for a group",
    true,
    [ IsGroup and IsFpGroup ],
    0,
        
function( G )
  return [false,        # we create levels dynamically
          false,        # we do not assume HasseProperty
          false,        # we assume we cannot compare groups efficiently
          false,        # we don't want the trivial subgroup
          MenuOpsForFpGroups,
          InfoDisplaysForFpGroups];
end);

