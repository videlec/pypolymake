#!/usr/bin/env python

import random
import polymake
import unittest

class TestPolymakeRational(unittest.TestCase):
    def test_cmp(self):
        a = 2
        b = 3
        pa = polymake.number.Integer(2)
        pb = polymake.number.Integer(3)
        qa = polymake.number.Rational(2)
        qb = polymake.number.Rational(3)
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

    def test_init(self):
        self.assertTrue(polymake.number.Rational(-2,4) ==
                        polymake.number.Rational(2,-4) ==
                        polymake.number.Rational(-1,2) ==
                        polymake.number.Rational(1,-2))

    def test_binop(self):
        a = polymake.number.Rational(1,2)
        b = polymake.number.Rational(2,3)
        self.assertTrue(a + b == polymake.number.Rational(7,6))

        for _ in range(100):
            anum = random.randint(-10,10)
            aden = random.randint(1,10)
            bnum = random.randint(-10,10)
            bden = random.randint(1,10)
            a = polymake.number.Rational(anum, aden)
            b = polymake.number.Rational(bnum, bden)
            self.assertTrue(a + b == polymake.number.Rational(anum*bden + bnum*aden, aden*bden))
            self.assertTrue(a - b == polymake.number.Rational(anum*bden - bnum*aden, aden*bden))
            self.assertTrue(a * b == polymake.number.Rational(anum*bnum, aden*bden))
            if bnum:
                self.assertTrue(a / b == polymake.number.Rational(anum*bden, aden*bnum))

if __name__ == '__main__':
    unittest.main()
