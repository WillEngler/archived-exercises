__author__ = 'willengler'
import unittest
from conjugate import regular


class TestRegularVerbsPresent(unittest.TestCase):
    def test_ir_present(self):
        
        conjugation_table = {
            'yo': 'vivo',
            'tú': 'vives',
            'Usted': 'vive',
            'él': 'vive',
            'ella': 'vive',
            'nosotros': 'vivimos',
            # vosotros is not used in Latin America, but I include it for completeness.
            'vosotros': 'vivís',
            'vosotras': 'vivís',
            'Ustedes': 'viven',
            'ellos': 'viven',
            'ellas': 'viven'
        }


        for person, conjugation in conjugation_table.items():
            self.assertEqual(regular.conjugate('vivir', person, 'present'), conjugation)

    def test_ar_verb(self):

        conjugation_table = {
            'yo': 'hablo',
            'tú': 'hablas',
            'Usted': 'habla',
            'él': 'habla',
            'ella': 'habla',
            'nosotros': 'hablamos',
            'vosotros': 'habláis',
            'vosotras': 'habláis',
            'Ustedes': 'hablan',
            'ellos': 'hablan',
            'ellas': 'hablan'
        }

        for person, conjugation in conjugation_table.items():
            self.assertEqual(regular.conjugate('hablar', person, 'present'), conjugation)

    def test_er_verb(self):

        conjugation_table = {
            'yo': 'como',
            'tú': 'comes',
            'Usted': 'come',
            'él': 'come',
            'ella': 'come',
            'nosotros': 'comemos',
            'vosotros': 'coméis',
            'vosotras': 'coméis',
            'Ustedes': 'comen',
            'ellos': 'comen',
            'ellas': 'comen'
        }

        for person, conjugation in conjugation_table.items():
            self.assertEqual(regular.conjugate('comer', person, 'present'), conjugation)