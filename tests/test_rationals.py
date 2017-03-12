#!/usr/bin/env python

import random
import polymake
import unittest

class TestPolymakeRational(unittest.TestCase):
    def test_init(self):
        self.assertTrue(polymake.rational.Rational(-2,4) ==
                        polymake.rational.Rational(2,-4) ==
                        polymake.rational.Rational(-1,2) ==
                        polymake.rational.Rational(1,-2))

        with self.assertRaises(ValueError):
             polymake.rational.Rational(0,0)
        with self.assertRaises(ValueError):
            polymake.rational.Rational(2,0)

    def test_bool(self):
        self.assertEqual(bool(polymake.rational.Rational(0,1)), False)
        self.assertEqual(bool(polymake.rational.Rational(1,1)), True)
        self.assertEqual(bool(polymake.rational.Rational(-1,2)), True)
        self.assertEqual(bool(polymake.rational.Rational(2,3)), True)
        self.assertEqual(bool(polymake.rational.Rational(-2,1)), True)

    def test_cmp(self):
        a = 2
        b = 3
        pa = polymake.integer.Integer(2)
        pb = polymake.integer.Integer(3)
        qa = polymake.rational.Rational(2)
        qb = polymake.rational.Rational(3)
        self.assertTrue(qa == qa and pa == qa and qa == pa and qa == a and a == qa)

        self.assertTrue(qa != qb and pa != qb and qa != pb and qa != b and a != qb)
        self.assertTrue(qa <  qb and pa <  qb and qa <  pb and qa <  b and a <  qb)
        self.assertTrue(qa <= qb and pa <= qb and qa <= pb and qa <= b and a <  qb)

        self.assertTrue(qb >= qa and pb >= qa and qb >= pa and qb >= a and b >= qa)
        self.assertTrue(qb >  qa and pb >  qa and qb >  pa and qb >  a and b >= qa)

        self.assertFalse(qa != qa or pa != qa or qa != pa or qa != a or a != qa)

        self.assertFalse(qa == qb or pa == qb or qa == pb or qa == b or a == qb)
        self.assertFalse(qa >= qb or pa >= pb or pa >= pb or qa >= b or a >= qb)
        self.assertFalse(qa >  qb or pa >  pb or pa >  pb or qa >  b or a >  qb)

        self.assertFalse(qb <= qa or pb <= qa or qb <= pa or qb <= a or b <= qa)
        self.assertFalse(qb <  qa or pb <  qa or qb <  pa or qb <  a or b <  qa)

    def test_binop(self):
        a = polymake.rational.Rational(1,2)
        b = polymake.rational.Rational(2,3)
        self.assertTrue(a + b == polymake.rational.Rational(7,6))

        for _ in range(100):
            anum = random.randint(-10,10)
            aden = random.randint(1,10)
            bnum = random.randint(-10,10)
            bden = random.randint(1,10)
            a = polymake.rational.Rational(anum, aden)
            b = polymake.rational.Rational(bnum, bden)
            self.assertTrue(a + b == polymake.rational.Rational(anum*bden + bnum*aden, aden*bden))
            self.assertTrue(a - b == polymake.rational.Rational(anum*bden - bnum*aden, aden*bden))
            self.assertTrue(a * b == polymake.rational.Rational(anum*bnum, aden*bden))
            if bnum:
                self.assertTrue(a / b == polymake.rational.Rational(anum*bden, aden*bnum))

            ones = [1, polymake.integer.Integer(1)]
            for o in ones:
                msg = "a = {}  type(o) = {}".format(a, type(o))
                self.assertTrue(a + o == polymake.rational.Rational(anum+aden, aden), msg)
                self.assertTrue(o + a == polymake.rational.Rational(anum+aden, aden), msg)
                self.assertTrue(a - o == polymake.rational.Rational(anum-aden, aden), msg)
                self.assertTrue(o - a == polymake.rational.Rational(aden-anum, aden), msg)
            twos = [2, polymake.integer.Integer(2)]
            for t in twos:
                msg = "a = {}  type(t) = {}".format(a, type(t))
                self.assertTrue(a * t == polymake.rational.Rational(2*anum, aden), msg)
                self.assertTrue(t * a == polymake.rational.Rational(anum*2, aden), msg)
                self.assertTrue(a / t == polymake.rational.Rational(anum, aden*2), msg)
# this is not supported yet
#                if anum:
#                    self.assertTrue(t / a == polymake.rational.Rational(2*aden, anum), msg)

    def test_zero_division(self):
        zeros = [0, polymake.integer.Integer(0), polymake.rational.Rational(0)]
        rats = [polymake.rational.Rational(0,1), polymake.rational.Rational(1,1)]
        for z in zeros:
            for r in rats:
                with self.assertRaises(ZeroDivisionError):
                    r / z

if __name__ == '__main__':
    unittest.main()
