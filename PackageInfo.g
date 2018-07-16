#############################################################################
##  
##  PackageInfo.g for the GAP SubgroupLattice
##

SetPackageInfo( rec(

PackageName := "SubgroupLattice",
Subtitle    := "Subgroup Lattice using Francy.s",
Version     := "0.1.0",
Date        := "10/07/2018",

Persons := [
  rec( 
    LastName      := "Martins",
    FirstNames    := "Manuel",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "manuelmachadomartins@gmail.com",
    WWWHome       := "http://github.com/mcmartins",
    Institution   := "Universidade Aberta",
    Place         := "Lisbon, PT"
  )
],

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status         := "dev",
CommunicatedBy := "TBD",

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/mcmartins/subgroup-lattice",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://github.com/mcmartins/subgroup-lattice",
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/subgroup-lattice-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := 
  "The <span class=\"pkgname\">SubgroupLattice</span> package provides an interface to interact with groups by displaying lattices.",

PackageDoc := rec(
  BookName         := "SubgroupLattice",
  ArchiveURLSubset := [ "htm","doc" ],
  HTMLStart        := "htm/chapters.htm",
  PDFFile          := "doc/manual.pdf",
  SixFile          := "doc/manual.six",
  LongTitle        := "SubgroupLattice using Francy - A Framework for Interactive Discrete Mathematics"
),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [ [ "francy", ">= 0.5.6" ] ],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := function() return true; end,

TestFile := "tst/testall.g",

Keywords := [ "Subgroup Lattice", "Interactive", "Graphics" ]

));
