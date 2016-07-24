#/usr/bin/env python

import random
import polymake
import unittest

class TestPolymakeInteger(unittest.TestCase):
    def test_bool(self):
        self.assertEqual(bool(polymake.number.Integer(0)), False)
        self.assertEqual(bool(polymake.number.Integer(1)), True)
        self.assertEqual(bool(polymake.number.Integer(-1)), True)

    def test_cmp(self):
        a = polymake.number.Integer(2)
        b = polymake.number.Integer(3)
        self.assertTrue(a == a)
        self.assertTrue(a != b)
        self.assertTrue(a < b)
        self.assertTrue(a <= b)
        self.assertTrue(b >= a)
        self.assertTrue(b > a)
        self.assertFalse(a != a)
        self.assertFalse(a == b)
        self.assertFalse(a >= b)
        self.assertFalse(a > b)
        self.assertFalse(b <= a)
        self.assertFalse(b < a)

    def test_binop(self):
        for _ in range(30):
            a = random.randint(-100, 100)
            b = random.randint(-100, 100)
            pa = polymake.number.Integer(a)
            pb = polymake.number.Integer(b)
            self.assertEqual(pa+pb, polymake.number.Integer(a+b))
            self.assertEqual(pa*pb, polymake.number.Integer(a*b))
            self.assertEqual(pa-pb, polymake.number.Integer(a-b))

    def test_python_int(self):
        # comparison with Python integers
        a = polymake.number.Integer(2)
        b = polymake.number.Integer(3)
        self.assertTrue(a == 2 and 2 == a)
        self.assertTrue(b == 3 and 3 == b)
        self.assertTrue(a != 3 and 3 != a)
        self.assertTrue(b != 2 and 2 != b)
        self.assertTrue(1 < a < 3)

if __name__ == '__main__':
    unittest.main()
