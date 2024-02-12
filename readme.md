This repository is for problem specifications written in Essence.

Each problem may contain a README file containing notes and findings
about the problem. (Though most problems do not.)

Optionally, each problem may also contain:

-   parameter and solution files for known/published instances.
-   scripts to generate random parameter files.

See [Directory structure](#directory-structure) for an explanation on
how things are organised.

# Old Version

An older version of the Essence Catalog is referenced from [The
Automated Modelling of Constraint
Programs](http://www.cs.york.ac.uk/aig/constraints/AutoModel/) webpage
hosted at the University of York. Unfortunately this version is not
available at the moment. We found a version of it on the [Wayback
machine](http://web.archive.org/web/20150402222531/http://www.cs.york.ac.uk/aig/constraints/AutoModel/Essence/specs120/)
which can be used in case you need to refer to that version.

# Relation to CSPLib

[CSPLib](http://www.csplib.org) is a library of problems specified in
natural language. Its code is hosted at
[GitHub](http://github.com/csplib/csplib).

This repository uses CSPLib as a submodule.

We will try to make sure that:

-   all the Essence files hosted on CSPLib are included in the Essence
    Catalog, and
-   if an Essence file is added to the Essence Catalog, it will be moved
    to CSPLib as soon as possible (when we have a natural language
    problem specification ready).

# Scripts

Some scripts are provided to keep the repository synchronised with
CSPLib.

-   Use `scripts/export_to_csplib.sh` for exporting Essence problem
    specification to the CSPLib submodule.
-   Use `scripts/import_from_csplib.sh` for importing Essence problem
    specification from the CSPLib submodule.

# EssenceCatalog-runs repository

See the
[EssenceCatalog-runs](https://github.com/conjure-cp/EssenceCatalog-runs)
repository for generated Essence Prime models, and various runtime
statistics.

# Directory structure

-   | Essence files:
    | `problems/[problem]/[essence].essence`.

    | Where `[problem]` is the name of the problem, and `[essence]` is
      the name of the problem specification in Essence.

-   | Essence parameter files:
    | `problems/[problem]/params` or
      `problems/[problem]/[essence]-params`.

    | The union of both of these directories will be taken, so either
      can be used on a case by case basis.

# License

All files in this repository are licensed under [Creative Commons
Attribution 4.0 International
License](http://creativecommons.org/licenses/by/4.0/).
