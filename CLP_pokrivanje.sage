#!/usr/bin/env python
# coding: utf-8

import json
import sys
import time

def pokrivanje(n, r=1):
    meja = floor(sqrt((n * (n + 1) * (2*n + 1)) / (r * 6)))
    p = MixedIntegerLinearProgram(maximization=True)

    w = p.new_variable(binary=True)
    y = p.new_variable(binary=True)
    z = p.new_variable(binary=True)
    p.set_objective(sum(z[l] for l in range(1, meja + 1))) ##ciljna funkcija
    p.add_constraint(z[0] == 1) ## robni pogoj, kvadrat velikosti 0 lahko vedno pokrijemo
    for i in range(1, n + 1):
        p.add_constraint(sum(w[i,u,v] for u in range(1, meja + 1) for v in range(1, meja + 1)) == 1) ##pogoj, da imamo največ en kvadrat dolžine i
    for j in range(1, meja + 1):
        for k in range(1, meja + 1):
            p.add_constraint(r*y[j,k] <= sum(w[i,u,v] ## pogoj, da je kvadratek (j,k) pokrit vsaj r-krat
                                             for i in range(1, n + 1)
                                             for u in range(max(1, j - i + 1), j + 1)
                                             for v in range(max(1, k - i + 1), k + 1)))
    for l in range(1, meja + 1):
        p.add_constraint(2*l*z[l] <= (z[l-1] + y[l,l] + sum((y[m,l] +y[l,m]) for m in range(1, l)))) ## pogoj, da je kvadrat lxl pokrit

    t = p.solve()  ##vrne velikost največjega kvadrata, ki ga dobimo s pokrivanjem.


    resw = p.get_values(w)
    resy = p.get_values(y)
    resz = p.get_values(z)
    kvadratki = []
    for (x,y) in resy.items():
        if y == 1:
            kvadratki.append(x)
    KVADRATI = []
    for (x,y) in resw.items():
        if y == 1:
            KVADRATI.append(x)

    return (t, KVADRATI)  ## vrne izhodišča kvadratov v optimalni rešitvi

def pozeni(n, r=1, podatki=None, datoteka='pokrivanje.json'):
    if podatki is None:
        podatki = {}
    print(f"pokrivanje({n}, {r})", end=" ")
    sys.stdout.flush()
    start = time.time()
    t, kvadrati = pokrivanje(n, r)
    end = time.time()
    cas = end-start
    print(f"-> {t}, cas = {cas:.2f}")
    podatki[n, r] = (t, kvadrati, cas)
    with open(datoteka, "w") as f:
        json.dump([{"n": int(nn), "r": int(rr), "velikost": int(t), "kvadrati": kv, "cas": c}
                  for (nn, rr), (t, kv, c) in podatki.items()], f, indent=4)

def preberi_podatke():
    try:
        with open(datoteka) as f:
            podatki = {(d["n"], d["r"]): (d["velikost"], d["kvadrati"], d["cas"]) for d in json.load(f)}
    except (FileNotFoundError, json.JSONDecodeError):
        print("Branje ni uspelo, začenjam znova")
        podatki = {}
    return podatki
