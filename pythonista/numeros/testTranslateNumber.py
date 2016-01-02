# -*- coding: utf-8 -*-
__author__ = 'willengler'
import unittest
from numeros import translateNumber


# "Unit test" en español es ¨prueba unitaria¨
class TestTranslateNumber(unittest.TestCase):

    def test_single_digit(self):
        self.assert_correct_translation('5', 'cinco')
        self.assert_correct_translation('6', 'seis')
        self.assert_correct_translation('9', 'nueve')

    def test_teens(self):
        self.assert_correct_translation('11', 'once')
        self.assert_correct_translation('16', 'dieciséis')
        self.assert_correct_translation('17', 'diecisiete')

    def test_two_digits(self):
        self.assert_correct_translation('21', 'veintiuno')
        self.assert_correct_translation('42', 'cuarenta y dos')
        self.assert_correct_translation('67', 'sesenta y siete')

    def test_hundreds(self):
        self.assert_correct_translation('100', 'cien')
        self.assert_correct_translation('143', 'ciento cuarenta y tres')
        self.assert_correct_translation('411', 'cuatrocientos once')
        self.assert_correct_translation('957', 'novecientos cincuenta y siete')

    def test_thousands(self):
        self.assert_correct_translation('2000', 'dos mil')
        self.assert_correct_translation('5892', 'cinco mil ochocientos noventa y dos')
        self.assert_correct_translation('9999', 'nueve mil novecientos noventa y nueve')

    def test_ten_thousands(self):
        self.assert_correct_translation('12843', 'doce mil ochocientos cuarenta y tres')

    def test_hundred_thousands(self):
        self.assert_correct_translation('302123', 'trescientos dos mil ciento veintitres')

    def test_millions(self):
        self.assert_correct_translation('1000000', 'un millón')
        self.assert_correct_translation('6543914', 'seis millones quinientos cuarenta y tres mil novecientos catorce')

    def assert_correct_translation(self, number, expected_translation):
        self.assertEqual(translateNumber.to_spanish_string(number), expected_translation)