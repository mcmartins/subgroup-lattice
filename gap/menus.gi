BindGlobal( "MenuOpsForFiniteGroups",
[ rec( name := "All Subgroups",
       func := function(poset, G)
            local L, cls, len, sz, graphHasse, max, rep, z, t, i, j, k, nodes, last, knownArgs, m, cb, link;

            L:=LatticeSubgroups(G);;
            cls:=ConjugacyClassesSubgroups(L);
            len:=[]; sz:=[];
            for i in cls do
              Add(len,Size(i));
              AddSet(sz,Size(Representative(i)));
            od;

            graphHasse := poset!.graph;
            UnsetNodes(graphHasse); # initialize nodes
            UnsetLinks(graphHasse); # initialize links

            nodes := [];
            sz:=Reversed(sz);

            # subgroup nodes, also acccording to size
            for i in [1..Length(cls)] do
              nodes[i] := [];
              for j in [1..len[i]] do
                if len[i]=1 then
                    nodes[i][j] := Shape(ShapeType.DIAMOND, String(i));
                else
                    nodes[i][j] := Shape(ShapeType.CIRCLE, String(i));
                fi;
                SetLayer(nodes[i][j], -Size(Representative(cls[i])));
                for m in poset!.latticeType.contextMenus do
                  knownArgs := [poset, Representative(cls[i])];
                  if m.group = true then
                    Add(knownArgs, G);
                  fi;
                  cb := Callback(m.func, knownArgs);
                  Add(nodes[i][j], Menu(m.name, cb));
                od;
                if i = Length(cls) and j = len[i] then
                  SetTitle(nodes[i][j], "G"); # set G
                fi;
                SetConjugateId(nodes[i][j], i);
                Add(graphHasse, nodes[i][j]);
              od;
            od;

            # uniform layers hack
            last:=rec(o:=0,n:=0);
            for i in [1..Length(cls)] do
              for j in [1..len[i]] do
                if Layer(nodes[i][j]) <> last.o then
                  last.o := Layer(nodes[i][j]);
                  last.n := last.n - 2;
                fi;
                SetLayer(nodes[i][j], last.n);
              od;
            od;

            max:=MaximalSubgroupsLattice(L);
            for i in [1..Length(cls)] do
              for j in max[i] do
                rep:=ClassElementLattice(cls[i],1);
                for k in [1..len[i]] do
                  if k=1 then
                    z:=j[2];
                  else
                     t:=cls[i]!.normalizerTransversal[k];
                    z:=ClassElementLattice(cls[j[1]],1); # force computation of transv.
                    z:=cls[j[1]]!.normalizerTransversal[j[2]]*t;
                    z:=PositionCanonical(cls[j[1]]!.normalizerTransversal,z);
                  fi;
                  Add(graphHasse, Link(nodes[j[1]][z], nodes[i][k]));
                od;
              od;
            od;
            return Draw(poset);
        end, multiple := false, group := true ),
  #rec( name := "Centralizers", func := Centralizer ),
  #rec( name := "Centres", func := Centre ),
  #rec( name := "Closures", func := ClosureGroup ),
  #rec( name := "Commutator Subgroups", func := CommutatorSubgroup ),
  #rec( name := "Conjugate Subgroups",
  #     func := {G, H} -> AsList(ConjugacyClassSubgroups(G, H))),
  #rec( name := "DerivedSeries", func := DerivedSeriesOfGroup ),
  #rec( name := "Fitting Subgroups", func := FittingSubgroup ),
  #rec( name := "Normal Closures", func := NormalClosure ),
  #rec( name := "Normal Subgroups", func := NormalSubgroups ),
  #rec( name := "Sylow Subgroups", func := GGLSylowSubgroup ),
] );

BindGlobal( "MenuOpsCommon",
[ #rec( name := "DerivedSubgroups", func := DerivedSubgroup ),
  #rec( name := "Cores", func := Core ),
  #rec( name := "Closure", func := GGLClosureGroup ),
  #rec( name := "Intermediate Subgroups", func := IntermediateSubgroups ),
  #rec( name := "Intersection", func := Intersection ),
  #rec( name := "Intersections", func := Intersection ),
  #rec( name := "Normalizers", func := Normalizer ),
] );

BindGlobal( "MenuOpsForFpGroups",
[ #rec( name := "Abelian Prime Quotient", func := GGLAbelianPQuotient ),
  #rec( name := "All Overgroups", func := IntermediateSubgroups ),
  #rec( name := "Compare Subgroups", func := GGLCompareSubgroups ),
  #rec( name := "Conjugacy Class",
  #     func := {G, H} -> Filtered(AsList(ConjugacyClassSubgroups(G,H)), h -> h <> H)),
  #rec( name := "Epimorphisms (GQuotients)", func := GGLEpimorphisms ),
  #rec( name := "Low Index Subgroups", func := GGLLowIndexSubgroups ),
  #rec( name := "Prime Quotient", func := GGLPrimeQuotient ),
  #rec( name := "Test Conjugacy", func := GGLTestConjugacy )
] );

BindGlobal( "ContextMenuOpsForFiniteGroups",
  [ rec( name := "Size",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Size",  String(Size(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    #rec( name := "Index",
    #     func := function(poset, n)
    #          local message;
    #          message := FrancyMessage(FrancyMessageType.INFO, "Index",  String(Index(n)));
    #          Add(poset, message);
    #          return Draw(poset);
    #     end, group := true ),
    rec( name := "IsAbelian",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is commutative?",  String(IsCommutative(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    #rec( name := "IsCentral",
    #     func := function(poset, n)
    #          local message;
    #          message := FrancyMessage(FrancyMessageType.INFO, "Is central?",  String(IsCentral(n)));
    #          Add(poset, message);
    #          return Draw(poset);
    #     end, group := false ),
    rec( name := "IsCyclic",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is cyclic?",  String(IsCyclic(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    rec( name := "IsNilpotent",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is NilpotentGroup?",  String(IsNilpotentGroup(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    rec( name := "IsNormal",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is normal?",  String(IsNormal(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := true ),
    rec( name := "IsPerfect",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is perfect group?",  String(IsPerfectGroup(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    rec( name := "IsSimple",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is simple group?",  String(IsSimpleGroup(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    rec( name := "IsSolvable",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Is solvable group?",  String(IsSolvableGroup(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
    rec( name := "Isomorphism",
         func := function(poset, n)
              local message;
              message := FrancyMessage(FrancyMessageType.INFO, "Isomorphism",  String(IdGroup(n)));
              Add(poset, message);
              return Draw(poset);
         end, group := false ),
  ] );

BindGlobal( "ContextMenuOpsForFpGroups",
  [ rec( name := "Index", func := Index ),
    rec( name := "IsNormal", func := IsNormal ),
    rec( name := "IsFpGroup", func := IsFpGroup ),
    rec( name := "IsSubgroupFpGroup", func := IsSubgroupFpGroup ),
    rec( name := "Abelian Invariants", func := AbelianInvariants ),
    rec( name := "CosetTable", func := CosetTableInWholeGroup ),
    rec( name := "IsomorphismFpGroup", func := IsomorphismFpGroup ),
    rec( name := "FactorGroup",
         func := function(G, N);
          if IsNormal(G, N) then
            return FactorGroup(G, N);
          else
            return "subgroup is not normal";
          fi;
         end )
  ] );
