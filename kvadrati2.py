from sage.plot.polygon import polygon


class Kvadrat2:

    def __init__(self, dolzina_stranice, x, y):
        self.x = x - 1
        self.y = y - 1
        self.dolzina_stranice = dolzina_stranice

    def narisi(self, barva="red"):
        return polygon(
            [(self.x, self.y), (self.x + self.dolzina_stranice, self.y),
             (self.x + self.dolzina_stranice, self.y + self.dolzina_stranice),
             (self.x , self.y + self.dolzina_stranice )],
            color=barva,
            edgecolor='black',
            alpha=0.5,
            zorder=1)