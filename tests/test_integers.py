#!/usr/bin/env python

import random
import polymake
import unittest

class TestPolymakeInteger(unittest.TestCase):
    def test_bool(self):
        self.assertEqual(bool(polymake.integer.Integer(0)), False)
        self.assertEqual(bool(polymake.integer.Integer(1)), True)
        self.assertEqual(bool(polymake.integer.Integer(-1)), True)
        self.assertEqual(bool(polymake.integer.Integer(2)), True)
        self.assertEqual(bool(polymake.integer.Integer(-2)), True)

    def test_cmp(self):
        a = 2
        b = 3
        pa = polymake.integer.Integer(2)
        pb = polymake.integer.Integer(3)
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
            pa = polymake.integer.Integer(a)
            pb = polymake.integer.Integer(b)

            # Integer op Integer
            self.assertEqual(pa+pb, polymake.integer.Integer(a+b))
            self.assertEqual(pa*pb, polymake.integer.Integer(a*b))
            self.assertEqual(pa-pb, polymake.integer.Integer(a-b))

            # Integer op int
            self.assertEqual(pa+b, polymake.integer.Integer(a+b))
            self.assertEqual(pa*b, polymake.integer.Integer(a*b))
            self.assertEqual(pa-b, polymake.integer.Integer(a-b))

            # int op Integer
            self.assertEqual(a+pb, polymake.integer.Integer(a+b))
            self.assertEqual(a*pb, polymake.integer.Integer(a*b))
            self.assertEqual(a-pb, polymake.integer.Integer(a-b))

    def test_zero_division(self):
        zeros = [0, polymake.integer.Integer(0), polymake.rational.Rational(0)]
        rats = [polymake.integer.Integer(0), polymake.integer.Integer(1)]
        for z in zeros:
            for r in rats:
                with self.assertRaises(ZeroDivisionError):
                    r / z

if __name__ == '__main__':
    unittest.main()
