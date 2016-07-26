#!/usr/bin/env python

import random
import polymake
import unittest

class TestPolymakeInteger(unittest.TestCase):
    def test_bool(self):
        self.assertEqual(bool(polymake.number.Integer(0)), False)
        self.assertEqual(bool(polymake.number.Integer(1)), True)
        self.assertEqual(bool(polymake.number.Integer(-1)), True)
        self.assertEqual(bool(polymake.number.Integer(2)), True)
        self.assertEqual(bool(polymake.number.Integer(-2)), True)

    def test_cmp(self):
        a = 2
        b = 3
        pa = polymake.number.Integer(2)
        pb = polymake.number.Integer(3)
        self.assertTrue(pa == pa and a == pa and pa == a)
        self.assertTrue(pa != pb and a != pb and pa != b)
        self.assertTrue(pa <  pb and a <  pb and pa <  b)
        self.assertTrue(pa <= pb and a <= pb and pa <= b)

        self.assertTrue(pb >= pa and b >= pa and pb >= a)
        self.assertTrue(pb >  pa and b >  pa and pb >  a)

        self.assertFalse(pa != pa or a != pa or pa != a)
        self.assertFalse(pa == pb or a == pb or pa == b)
        self.assertFalse(pa >= pb or a >= pb or pa >= b)
        self.assertFalse(pa >  pb or a >  pb or pa >  b)

        self.assertFalse(pb <= pa or b <= pa or pb <= a)
        self.assertFalse(pb <  pa or b <  pa or pb <  a)

    def test_binop(self):
        for _ in range(30):
            a = random.randint(-100, 100)
            b = random.randint(-100, 100)
            pa = polymake.number.Integer(a)
            pb = polymake.number.Integer(b)

            # Integer op Integer
            self.assertEqual(pa+pb, polymake.number.Integer(a+b))
            self.assertEqual(pa*pb, polymake.number.Integer(a*b))
            self.assertEqual(pa-pb, polymake.number.Integer(a-b))

            # Integer op int
            self.assertEqual(pa+b, polymake.number.Integer(a+b))
            self.assertEqual(pa*b, polymake.number.Integer(a*b))
            self.assertEqual(pa-b, polymake.number.Integer(a-b))

            # int op Integer
            self.assertEqual(a+pb, polymake.number.Integer(a+b))
            self.assertEqual(a*pb, polymake.number.Integer(a*b))
            self.assertEqual(a-pb, polymake.number.Integer(a-b))

if __name__ == '__main__':
    unittest.main()
