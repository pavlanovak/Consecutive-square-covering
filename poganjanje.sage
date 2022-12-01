#!/usr/bin/env python
# coding: utf-8

datoteka = 'pokrivanje.json'
podatki = preberi_podatke()
for n in range(1, 11): 
    for r in range(n, 0, -1): 
        pozeni(n, r, podatki=podatki, datoteka=datoteka)
