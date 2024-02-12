
The following constraint was used in an earlier version of this problem specification.

Keeping it here for reference.

.. code-block::

    such that
        forAll pair1_1, pair1_2 in Ticks , pair1_1 < pair1_2 .
            forAll pair2_1, pair2_2 in Ticks , pair2_1 < pair2_2 .
                (pair1_1, pair1_2) != (pair2_1, pair2_2)
                ->
                max({pair1_1, pair1_2}) - min({pair1_1, pair1_2}) !=
                max({pair2_1, pair2_2}) - min({pair2_1, pair2_2})

