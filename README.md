English:
Project entirely made by @m6ms

The goal is to retrieve the fundamental frequency and octave 
of different musical notes (piano/flute/violin) using two methods: 
autocorrelation and FFT.

To change files (if you want piano instead of violin for example)
just change the 12th line of the code.

The begginning of the code is used to get the power of the signal
made by the note and also to detect where is the signal (begin and end).

It will then plot signals with a red function where the signal is detected
(you can adjust the code with your own "pourcent_seuil")

Then there is the autocorrelation part where we will plot the autocorrelation
of the signal which is used to get the period and then the fundamental.
(you can adjust the code with your own "pourcent_peak")

And finally the fft part where you use the fast fourrier transform
to get the harmonics of the signal with the fundamental being the first one.
(you can adjust the code with your own "pourcent_peak2")

There is a little code to find the harmonics (it will detects only the k-times fundamental
frequences and only if it isn't just noise)

Then we print the octave and fundamental detected.

French:
Projet fait entièrement par @m6ms

L'objectif est de récupérer la fréquence fondamental et 
l'octave de différentes notes de musique (piano/flute/violon) 
par 2 méthodes: l'autocorrélation et la fft

Pour changer de fichier, changez la ligne 12 du code.

Le début du code permet de détecter où se trouve le signal.

Ensuite on aura les graphiques du signal et de sa puissance en W et en dBm
(vous pouvez ajuster le code en mettant votre propre "pourcent_seuil")

Ensuite il y a la méthode d'autocorrélation qui va afficher l'autocorrélation du signal
qui est utilisé pour en déduire la période du signal et donc le fondamental.
(vous pouvez ajuster le code en mettant votre propre "pourcent_peak")

Enfin vous avez la méthode par transformée de fourrier rapide qui nous permettra
de trouver le fondamental et ses harmoniques.
(vous pouvez ajuster le code en mettant votre propre "pourcent_peak2)

Il y a un petit code pour trouver seulement les harmoniques et non le bruit.

Et ensuite on affiche les octaves et fréquences fondamentales détectées.
