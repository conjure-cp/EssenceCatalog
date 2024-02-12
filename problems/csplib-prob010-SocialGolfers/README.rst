
Here is an alternative way of stating the problem constraint using comprehensions.

.. code::

    such that
        and([ |group1 intersect group2| < 2
            | week1  <- sched
            , group1 <- parts(week1)
            , week2  <- sched
            , group2 <- parts(week2)
            ])

