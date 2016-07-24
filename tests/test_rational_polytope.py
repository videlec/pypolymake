#!/usr/bin/env python

import polymake
import unittest

m1 = [[1,0,0,0], [1,0,0,1], [1,0,1,0], [1,0,1,1],  [1,1,0,0], [1,1,0,1], [1,1,1,0], [1,1,1,1]]
m2 = [[1,0,0,0], [1,(1,16),(1,4),(1,16)], [1,(3,8),(1,4),(1,32)],
       [1,(1,4),(3,8),(1,32)], [1,(1,16),(1,16),(1,4)], [1,(1,32),(3,8),(1,4)],
       [1,(1,4),(1,16),(1,16)], [1,(1,32),(1,4),(3,8)], [1,(3,8),(1,32),(1,4)],
       [1,(1,4),(1,32),(3,8)]]
m3 = [[1, 3, 0, 0], [1, 0, 3, 0], [1, 1, 1, 1], [1, 0, 0, 3]]
p1 = polymake.Polytope('POINTS', m1)
p2 = polymake.Polytope('POINTS', m2)
p3 = polymake.Polytope('POINTS', m3)

class TestPolymakePolytope(unittest.TestCase):
    def test_N_FACETS(self):
        self.assertEqual(p1.N_FACETS(), 6)
        self.assertEqual(p2.N_FACETS(), 13)
        self.assertEqual(p3.N_FACETS(), 3)

    def test_N_VERTICES(self):
        self.assertEqual(p1.N_VERTICES(), 8)
        self.assertEqual(p2.N_VERTICES(), 10)
        self.assertEqual(p3.N_VERTICES(), 3)

    def test_SIMPLE(self):
        self.assertTrue(p1.SIMPLE())
        self.assertFalse(p2.SIMPLE())
        self.assertTrue(p3.SIMPLE())

    def test_SIMPLICIAL(self):
        self.assertFalse(p1.SIMPLICIAL())
        self.assertFalse(p2.SIMPLICIAL())
        self.assertTrue(p3.SIMPLICIAL())

    def test_F_VECTOR(self):
        self.assertEqual(map(int, p1.F_VECTOR()), [8, 12, 6])
        self.assertEqual(map(int, p2.F_VECTOR()), [10, 21, 13])
        self.assertEqual(map(int, p3.F_VECTOR()), [3, 3])

if __name__ == '__main__':
    unittest.main()
