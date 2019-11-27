import csv
from random import *
from music import *
from midi import *

m = MidiOut("Apple Inc. Bus 1")
duration = WN                                 # duration for each note
tempo = 500

with open('temp.csv', 'rb') as f:
    reader = csv.reader(f)
    templist = list(reader)

flattened = [val for sublist in templist for val in sublist]

phrase = Phrase(0.0)
phrase.setTempo(tempo)

for i in flattened:
   i = float(i)
   pitch = mapScale(i, -0.37, 1.02, D3, D4, MINOR_SCALE)  
   n = Note(pitch, duration)
   phrase.addNote(n)
   

m.play(phrase)