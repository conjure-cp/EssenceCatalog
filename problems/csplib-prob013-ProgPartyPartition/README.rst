
Some "implied constraints" for this problem specification.

.. code::

    $ the range of each function has at least 1 element.
    $ this is because the functions are total, in the worst case
    $ when everything is mapped to a single item range still has to contain 1 element.
    forAll p in sched . minSize(range(p),1),

    $ since each range(p) is subsetEq hosts (from constraint 1)
    $ and since range(p) are minSize=1
    $ hosts must be minSize=1
    minSize(hosts, 1),

    $ |range(p)| >= |hosts| (from constraint 2)
    $ range(p) is a subset of hosts (from constraint 1)
    $ hence |range(p)| = |hosts|
    $ Ozgur: "forAll h in hosts . p(h) = h" IMPLIES "hosts subsetEq range(p)"
    $                                       AND     "hosts subsetEq defined(p)"
    $ range is already subsetEq hosts, hence: "hosts = range(p)"
    forAll p in sched . range(p) = hosts,

    $ due to p(h) = h
    forAll p in sched . forAll h in hosts . |preImage(p,h)| >= 1,

    $ non-hosts + host itself
    forAll p in sched . forAll h in hosts . |preImage(p,h)| <= n_boats - |hosts| + 1,

    $ in general "forAll h . a(h) < b(h)" -> "(sum h . a(h)) < (sum h . b(h))"
    forAll p in sched . (sum h in hosts . (sum b in preImage(p,h) . crew(b)))
                            <=
                        (sum h in hosts . capacity(h))


