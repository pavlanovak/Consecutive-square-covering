#!/usr/bin/env python
# coding: utf-8

datoteka = 'pokrivanje2.json'
podatki = preberi_podatke(datoteka)
for n in range(15, 21):
    for r in range(n, 1, -1):
        pozeni(n, r, podatki=podatki, datoteka=datoteka)
