# -*- coding: utf-8 -*-
__author__ = 'willengler'

import sys

single_digits = {
    '0': 'cero',
    '1': 'uno',
    '2': 'dos',
    '3': 'tres',
    '4': 'cuatro',
    '5': 'cinco',
    '6': 'seis',
    '7': 'siete',
    '8': 'ocho',
    '9': 'nueve',
}

tens = {
    '1': 'diez',
    '2': 'veinte',
    '3': 'treinta',
    '4': 'cuarenta',
    '5': 'cincuenta',
    '6': 'sesenta',
    '7': 'setenta',
    '8': 'ochenta',
    '9': 'noventa'
}

ten_stems = {
    '1': 'dieci',
    '2': 'veinti'
}

weird_teens = {
    '11': 'once',
    '12': 'doce',
    '13': 'trece',
    '14': 'catorce',
    '15': 'quince',
}

hundreds = {
    '1': 'ciento',
    '2': 'doscientos',
    '3': 'trescientos',
    '4': 'cuatrocientos',
    '5': 'quinientos',
    '6': 'seiscientos',
    '7': 'setecientos',
    '8': 'ochocientos',
    '9': 'novecientos'
}


def to_spanish_string(numero):
    if len(numero) > 10:
        raise Exception('Number can have a maximum of 9 digits.')

    if not 0 < int(numero) < 999999999:
        raise Exception('Can only translate nine-digit, positive numbers. Lo siento.')

    numero = standardize(numero)

    if int(numero) == 0:
        return 'cero'
    else:
        return str.strip(get_number(numero[0: 3], 'un millón ', ' millones ') +
                         get_number(numero[3: 6], 'mil ', ' mil ') +
                         get_number(numero[6: 9], 'uno', ''))


# Always operate on a 9-digit number. Pad with 0's if necessary
def standardize(numero):
    padding = '0'*(9 - len(numero))
    return padding + numero


def get_number(digits, string_for_one, standard_ending):

    # If this substring is zero, we skip it in the word
    if int(digits) == 0:
        return ''

    # If this substring is one, we need to handle the special case for millions
    # Where it is 'un millón' instead of 'millones'
    if int(digits) == 1:
        return string_for_one

    # Precisely 100 is another weird case
    if int(digits) == 100:
        return 'cien ' + standard_ending

    # Now onto the general case

    hundreds = get_hundreds(digits[0])
    the_rest = get_tens_and_ones(digits[1:])

    return hundreds + the_rest + standard_ending


def get_hundreds(digit):
    assert(len(digit) == 1)

    if digit == '0':
        return ''
    else:
        return hundreds[digit] + ' '


def get_tens_and_ones(digits):
    assert(int(digits) != 0)
    assert(len(digits) == 2)

    tens_place = digits[0]
    ones_place = digits[1]

    if tens_place == '0':
        return single_digits[ones_place]
    elif ones_place == '0':
        return tens[tens_place]
    elif tens_place == '1':
        return teen(digits)
    elif tens_place == '2':
        return twenty(digits)
    else:
        return generic_two_digit(digits)

#
# Helpers for get_tens_and_ones
#


def teen(digits):
    if int(digits[1]) < 6:
        return weird_teens[digits]
    else:
        return 'dieci' + get_ones_place(digits[1])


def twenty(numero):
    return 'veinti' + get_ones_place(numero[1])


# When seis is added to a tens stem, it must receive an accent mark
def get_ones_place(digit):
    if digit == '6':
        return 'séis'
    else:
        return single_digits[digit]


def generic_two_digit(digits):
    return tens[digits[0]] + ' y ' + single_digits[digits[1]]



if __name__ == "__main__":
    try:
        print(to_spanish_string(sys.argv[1]))
    except:
        print('Please enter a number as a command line argument.')