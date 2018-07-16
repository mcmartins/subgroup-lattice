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
InstallMethod(GraphicSubgroupLattice,
    "for a group, and a record",
    true,
    [IsGroup, IsRecord],
    0,
function(G, def)
  local latticeType, graph, poset, cls, vmath, v2, v1, menu, m, knownArgs, cb;

  latticeType := DecideSubgroupLatticeType(G);
  # we do some heuristics to avoid the trivial group:
  # if we know all levels, we probably can calc. Size, if we shall generate
  # a vertex for the trivial subgroup, we should also know Size!
  if latticeType.knowsLevels or latticeType.trivial then
    # no trivial case:
    if Size(G) = 1 then
      return Error( "<G> must be non-trivial" );
    fi;
  fi;

  # create a new canvas
  poset := Canvas("GraphicSubgroupLattice");
  # and make it a GraphicSubgroupLattice
  SetFilterObj(poset, IsGraphicSubgroupLattice);
  
  poset!.latticeType := latticeType;

  if HasName(G) then
    SetTitle(poset, Concatenation(Title(poset)," of ", Name(G)));
  elif HasIdGroup(G) then
    SetTitle(poset, Concatenation(Title(poset)," of ", String(IdGroup(G))));
  fi;

  if IsBound(def.width) then SetWidth(poset, def.width); fi;
  if IsBound(def.height) then SetHeight(poset, def.height); fi;
  if IsBound(def.title) then SetTitle(poset, def.title); fi;

  # now the other filters, depending on type:
  if latticeType.knowsLevels then SetFilterObj(poset, KnowsAllLevels); fi;
  if latticeType.hasse then SetFilterObj(poset, HasseProperty); fi;
  if latticeType.canCompare then SetFilterObj(poset, CanCompareSubgroups); fi;

  if KnowsAllLevels(poset) then
    # we know how many levels so we can show the user
    Add(poset, FrancyMessage(Concatenation("There are ",
      String(Length(DivisorsInt(Size(G)))), " levels in this Group.")));
  else
    # we don't know how many levels so we try to compute them
    if latticeType.trivial then
      if CanComputeSize(G) and Size(G) <> infinity then
        Add(poset, FrancyMessage(Concatenation("There are ", String(Size(G)), " levels in this Group.")));
      else
        Add(poset, FrancyMessage("We don't know how many levels there are on this group."));
      fi;
    else
      # we really don't know
      Add(poset, FrancyMessage("We don't know how many levels there are on this group."));
    fi;
  fi;

  # create an undirected graph to represent the poset
  # by adding layers later, the undirected graph turns
  # into an Hasse diagram
  graph := Graph(GraphType.UNDIRECTED);
  Add(poset, graph);
  
  cls:=ConjugacyClassesSubgroups(G);

  # create one or two initial vertices (G itself and trivial subgroup):
  v2 := Shape(ShapeType.DIAMOND, "G");
  SetLayer(v2, -4);
  for m in latticeType.contextMenus do
    knownArgs := [poset, Representative(cls[Length(cls)])];
    if m.group = true then
      Add(knownArgs, G);
    fi;
    cb := Callback(m.func, knownArgs);
    Add(v2, Menu(m.name, cb));
  od;
  Add(graph, v2);

  if latticeType.trivial then
    v1 := Shape(ShapeType.DIAMOND, "1");
    SetLayer(v1, 0);
    for m in latticeType.contextMenus do
      knownArgs := [poset, Representative(cls[1])];
      if m.group = true then
        Add(knownArgs, G);
      fi;
      cb := Callback(m.func, knownArgs);
      Add(v1, Menu(m.name, cb));
    od;
    Add(graph, v1);
    
    # connect the two vertices
    Add(graph, Link(v1, v2));
  fi;

  # <G> is selected at first
  v2!.selected := true;

  # create menus:
  menu := Menu("Subgroup Lattice");
  for m in latticeType.menus do
    knownArgs := [poset];
    if m.group = true then
      Add(knownArgs, G);
    fi;
    cb := Callback(m.func, knownArgs);
    Add(menu, Menu(m.name, cb));
  od;
  Add(poset, menu);

  return Draw(poset);
end);

##
## without defaults record:
##
InstallOtherMethod(GraphicSubgroupLattice,
    "for a group",
    true,
    [IsGroup],
    0,
function(G)
  return GraphicSubgroupLattice(G, rec());
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
##  Returns a record. The first four entries are boolean values for  questions
##  1-4. Note that if the answer to 2 is true, then the answer to 3 must also
##  be true. The fifth and sixth entry are configuration lists as explained
##  in the configuration section of "ilatgrp.gi" for menu operations and
##  info displays respectively.
##
##  The following is the default "fallback" method suitable for reasonably
##  small finite groups.
##
InstallMethod(DecideSubgroupLatticeType,
    "for a group",
    true,
    [IsGroup],
    0,
function(G)
  local knowslevels, menus;
  menus:=[];
  Append(menus, MenuOpsForFiniteGroups);
  Append(menus, MenuOpsCommon);
  if Size(G) > 10^17 then # that is just heuristic!
    knowslevels := false;
  else
    knowslevels := Length(DivisorsInt(Size(G))) < 50;
  fi;
  return rec(
    knowsLevels  := knowslevels,
    hasse        := true, # we assume HasseProperty
    canCompare   := true, # we assume we can compare groups
    trivial      := true, # we want the trivial subgroup
    menus        := menus,
    contextMenus := ContextMenusForFiniteGroups,
  );
end);

## for finitely presented groups:
InstallMethod(DecideSubgroupLatticeType,
    "for a group",
    true,
    [IsGroup and IsFpGroup],
    0,

function(G)
  local menus;
  menus:=[];
  Append(menus, MenuOpsForFpGroups);
  Append(menus, MenuOpsCommon);
  return rec(
    knowsLevels  := false, # we create levels dynamically
    hasse        := false, # we assume HasseProperty
    canCompare   := false, # we assume we can compare groups
    trivial      := false, # we want the trivial subgroup
    menus        := menus,
    contextMenus := ContextMenusForFpGroups,
  );
end);
