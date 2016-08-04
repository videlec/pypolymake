#!/usr/bin/env python

import polymake
import unittest

m1 = [[1,0,0,0], [1,0,0,1], [1,0,1,0], [1,0,1,1],  [1,1,0,0], [1,1,0,1], [1,1,1,0], [1,1,1,1]]
m2 = [[1,0,0,0], [1,(1,16),(1,4),(1,16)], [1,(3,8),(1,4),(1,32)],
       [1,(1,4),(3,8),(1,32)], [1,(1,16),(1,16),(1,4)], [1,(1,32),(3,8),(1,4)],
       [1,(1,4),(1,16),(1,16)], [1,(1,32),(1,4),(3,8)], [1,(3,8),(1,32),(1,4)],
       [1,(1,4),(1,32),(3,8)]]
m3 = [[1, 3, 0, 0], [1, 0, 3, 0], [1, 1, 1, 1], [1, 0, 0, 3]]
m4 = [[(-20, 9), (-19, 1), (-8, 7), (-11, 13), (-9, 20)],
      [(-13, 1), (1, 2), (20, 13), (5, 2), (-19, 12)],
      [(-2, 3), (-9, 8), (-11, 13), (2, 1), (-4, 9)],
      [(-5, 4), (-18, 7), (5, 2), (-3, 2), (-3, 5)],
      [(-4, 3), (-7, 11), (-17, 3), (-5, 11), (-1, 9)],
      [(6, 1), (14, 19), (2, 11), (-5, 4), (-13, 2)],
      [(-3, 2), (-1, 4), (-15, 19), (-5, 1), (19, 2)],
      [(-4, 5), (1, 3), (4, 5), (3, 8), (9, 1)],
      [(-8, 9), (-4, 5), (1, 5), (17, 6), (-3, 1)],
      [(-3, 19), (-15, 1), (11, 2), (5, 19), (-2, 1)],
      [(4, 1), (-5, 7), (-6, 1), (-5, 4), (3, 5)]]
p1 = polymake.Polytope('POINTS', m1)
p2 = polymake.Polytope('POINTS', m2)
p3 = polymake.Polytope('POINTS', m3)
p4 = polymake.Polytope('POINTS', m4)

class TestPolymakePolytope(unittest.TestCase):
    def test_AFFINE_HULL(self):
        a3 = p3.AFFINE_HULL
        self.assertEqual(a3[0,0], -3)
        self.assertEqual(a3[0,1], 1)
        self.assertEqual(a3[0,2], 1)
        self.assertEqual(a3[0,3], 1)

    def test_ALTSHULER_DET(self):
        self.assertEqual(p1.ALTSHULER_DET, 0)
        self.assertEqual(p2.ALTSHULER_DET, 1872)
        self.assertEqual(p3.ALTSHULER_DET, 4)

    def test_BALANCE(self):
        self.assertEqual(p1.BALANCE, 1)
        self.assertEqual(p2.BALANCE, 1)
        self.assertEqual(p3.BALANCE, 2)

    def test_BALANCED(self):
        self.assertTrue(p1.BALANCED)
        self.assertTrue(p2.BALANCED)
        self.assertTrue(p3.BALANCED)

    def test_BOUNDED(self):
        self.assertTrue(p1.BOUNDED)
        self.assertTrue(p2.BOUNDED)
        self.assertTrue(p3.BOUNDED)

    def test_CENTERED(self):
        self.assertFalse(p1.CENTERED)
        self.assertFalse(p2.CENTERED)
        self.assertFalse(p3.CENTERED)

    def test_CENTRALLY_SYMMETRIC(self):
        self.assertFalse(p1.CENTRALLY_SYMMETRIC)
        self.assertFalse(p2.CENTRALLY_SYMMETRIC)
        self.assertFalse(p3.CENTRALLY_SYMMETRIC)

    def test_COCUBICAL(self):
        self.assertFalse(p1.COCUBICAL)
        self.assertFalse(p2.COCUBICAL)
        self.assertTrue(p3.COCUBICAL)

    def test_COMBINATORIAL_DIM(self):
        self.assertEqual(p1.COMBINATORIAL_DIM, 3)
        self.assertEqual(p2.COMBINATORIAL_DIM, 3)
        self.assertEqual(p3.COMBINATORIAL_DIM, 2)

    def test_CUBICAL(self):
        self.assertTrue(p1.CUBICAL)
        self.assertFalse(p2.CUBICAL)
        self.assertTrue(p3.CUBICAL)

    def test_CUBICAL_H_VECTOR(self):
        v = p1.CUBICAL_H_VECTOR
        self.assertEqual(v[0], 4)
        self.assertEqual(v[1], 4)
        self.assertEqual(v[2], 4)
        self.assertEqual(v[3], 4)

        v = p3.CUBICAL_H_VECTOR
        self.assertEqual(v[0], 2)
        self.assertEqual(v[1], 1)
        self.assertEqual(v[2], 2)

    def test_CUBICALITY(self):
        self.assertEqual(p1.CUBICALITY, 3)
        self.assertEqual(p2.CUBICALITY, 1)
        self.assertEqual(p3.CUBICALITY, 1)

    def test_DUAL_BOUNDED_H_VECTOR(self):
        v = p1.DUAL_BOUNDED_H_VECTOR
        self.assertEqual(v[0], 1)
        self.assertEqual(v[1], 3)
        self.assertEqual(v[2], 3)
        self.assertEqual(v[3], 1)

        v = p3.DUAL_BOUNDED_H_VECTOR
        self.assertEqual(v[0], 1)
        self.assertEqual(v[1], 1)
        self.assertEqual(v[2], 1)

    def test_N_FACETS(self):
        self.assertEqual(p1.N_FACETS, 6)
        self.assertEqual(p2.N_FACETS, 13)
        self.assertEqual(p3.N_FACETS, 3)

    def test_N_VERTICES(self):
        self.assertEqual(p1.N_VERTICES, 8)
        self.assertEqual(p2.N_VERTICES, 10)
        self.assertEqual(p3.N_VERTICES, 3)

    def test_SIMPLE(self):
        self.assertTrue(p1.SIMPLE)
        self.assertFalse(p2.SIMPLE)
        self.assertTrue(p3.SIMPLE)

    def test_SIMPLICIAL(self):
        self.assertFalse(p1.SIMPLICIAL)
        self.assertFalse(p2.SIMPLICIAL)
        self.assertTrue(p3.SIMPLICIAL)

    def test_F_VECTOR(self):
        self.assertEqual(map(int, p1.F_VECTOR), [8, 12, 6])
        self.assertEqual(map(int, p2.F_VECTOR), [10, 21, 13])
        self.assertEqual(map(int, p3.F_VECTOR), [3, 3])

if __name__ == '__main__':
    unittest.main()
