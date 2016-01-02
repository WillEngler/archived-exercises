__author__ = 'willengler'


def conjugate(verb, person, tense):
    return tense_dispatch[tense](verb, person)


def present_tense(verb, person):
    ir_endings = {
        'yo': 'o',
        'tú': 'es',
        'Usted': 'e',
        'él': 'e',
        'ella': 'e',
        'nosotros': 'imos',
        'vosotros': 'ís',
        'vosotras': 'ís',
        'Ustedes': 'en',
        'ellos': 'en',
        'ellas': 'en'
    }

    ar_endings = {
        'yo': 'o',
        'tú': 'as',
        'Usted': 'a',
        'él': 'a',
        'ella': 'a',
        'nosotros': 'amos',
        'vosotros': 'áis',
        'vosotras': 'áis',
        'Ustedes': 'an',
        'ellos': 'an',
        'ellas': 'an'
    }

    er_endings = {
        'yo': 'o',
        'tú': 'es',
        'Usted': 'e',
        'él': 'e',
        'ella': 'e',
        'nosotros': 'emos',
        'vosotros': 'éis',
        'vosotras': 'éis',
        'Ustedes': 'en',
        'ellos': 'en',
        'ellas': 'en'
    }

    ending_dispatch = {
        'ir': ir_endings,
        'ar': ar_endings,
        'er': er_endings
    }

    stem = verb[:-2]
    verb_type = verb[-2:]

    return stem + ending_dispatch[verb_type][person]



tense_dispatch = {
    'present': present_tense
}