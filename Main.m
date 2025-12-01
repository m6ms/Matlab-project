% -------------------------------------------------------
% Projet fait entièrement par @m6ms
% L'objectif est de récupérer la fréquence fondamental et 
% l'octave de différentes notes de musique (piano/flute/violon) 
% par 2 méthodes: l'autocorrélation et la fft
% -------------------------------------------------------

clc
clearvars
close all

[x, Fe] = audioread('Notes\ViolonNote01.mp3');  % Lecture audio
N = length(x);                                  % Nombre d'échantillons
t = (0:N-1)/Fe;                                 % Plage de temps
D = 0.01 * (N / Fe);                            % Durée fenêtre glissante, il y en aura 100

p = MyPowerEstimation(x, Fe, D);         % Calcul P instant W
PdBm = 10*log10(p/1e-3);                 % Calcul P instant dBm

pourcent_seuil = 0.003;                  % Seuil détection
S = pourcent_seuil * max(p);             % Identifier la plage du signal
sd = zeros(size(p));                     % Initialiser sd
sd(p > S) = 1;                           % Mettre des 1 où le signal est détecté

premier = find(sd,1,'first');            % Chercher la 1ère occurence de 1
dernier  = find(sd,1,'last');            % Chercher la dernière occurence de 1

t_debut = t(premier);                    % Prendre le 1er temps avec un 1
t_fin = t(dernier);                      % Prendre le dernier temps avec un 1
duree = t_fin - t_debut;                 % Durée du signal
if duree >= 0.5
    fprintf('La durée respecte la consigne des 0.5s\n');
else
    error('La durée ne respecte pas la consigne des 0.5s, fin du programme.');
end

subplot(3,2,1)                           % Plot du signal
plot(t, x);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal Original');
grid on;

subplot(3,2,2);                          % Plot PW
plot(t, p);
xlabel('Temps (s)');
ylabel('Puissance');
title('Puissance en W');
grid on;

subplot(3,2,3);                          % Plot PdBm
plot(t, PdBm);
xlabel('Temps (s)');
ylabel('Puissance');
title('Puissance en dBm');
grid on;

subplot(3,2,1); hold on; plot(t,sd, 'r');   % Afficher la plage du signal

fprintf('Signal détecté de %.2f s à %.2f s\n', t_debut, t_fin);
fprintf('Durée du signal: %.2fs\n', duree);

% Partie autocorrélation

x_detected = x(premier:dernier);            % Prendre que la partie du signal intéressant
x_detected = x_detected(:).';               % Convertir pour match les dimensions
[Cxx, tx] = MyAutocorrelation(x_detected, Fe, D);       % Faire l'autocorrélation

subplot(3,2,4)                              % Plot autocorrélation
plot(tx,Cxx)
xlabel('Temps (s)');
ylabel('Amplitude');
title('Autocorrélation');
grid on;

pourcent_peak = 0.63;                       % Mettre un pourcentage du pic pour détecter
minPeakHeight = pourcent_peak * max(Cxx);   % On prend le début de période à 63% du max
[peaks, locs] = findpeaks(Cxx, 'MinPeakHeight', minPeakHeight); % Prendre les pics
T_all = diff(tx(locs));                     % distances entre pics successifs
T0 = mean(T_all);                           % Prendre la moyenne des périodes
f0a = 1 / T0;                               % Trouver la fréquence f0

% Partie analyse spectrale

df = 0.1;                                       % Pas
M = Fe/df;                                      % Nombre de points
[f,xfm,dsp_db] = MyDSPEstimation(x,Fe,M);       % Module et DSP

subplot(3,2,5); % plot Module
plot(f,xfm); 
grid on
title 'Module'; 
xlabel('Hz');

subplot(3,2,6); % plot DSP
plot(f,dsp_db);
title 'DSP'; 
xlabel('Hz');
ylabel('dB');
grid on

% On utilise la même méthode que pour l'autocorrélation cette fois sur fft
pourcent_peak2 = 0.45;      % seuil détection fondamental
[pks, locs] = findpeaks(xfm,f, 'MinPeakHeight', pourcent_peak2*max(xfm));
f0f = locs(1);              % Fréquence fondamentale

amp_fh = sum(xfm)*0.9999/2; % On cherche 99.99% de l'amplitude
somme = 0;                  % On initialise à zero
i = 1;

while somme < amp_fh        % On fait une boucle jusqu'à obtenir 99.99%
    somme = somme + xfm(i);
    i = i + 1;
end
fh = f(i);                  % Déterminer la fréquence haute

% Recherche nombre harmonique
tol = 2 * df;                           % tolérance de recherche autour de k*f0f
noiseLevel = mean(xfm) + 2 * std(xfm);  % seuil adaptatif
harmFreqs = [];                         % on définit une liste d'harmoniques vide

k = 1;
while true      % On fait une boucle while qui va prendre tous les f0f*k 
    targetFreq = k * f0f;

    % On sort de la boucle si on est au-delà de fh
    if targetFreq > fh
        break;
    end

    % Chercher autour de k*f0f dans ± tol
    idx = find(abs(f - targetFreq) < tol);
    if isempty(idx)
        break;
    end

    [amp, locRel] = max(xfm(idx));
    locAbs = idx(locRel);

    % Est-ce une harmonique ou du bruit ?
    if amp > noiseLevel
        harmFreqs(end+1) = f(locAbs);
    end

    k = k + 1;
end

% Nombre d'harmoniques détectées
nb_harmoniques = length(harmFreqs);

% On définit une cell de notes et un vecteur de fréquences qui sont liés
% par leurs indices

notes = {
'C4', 'D4B', 'D4', 'E4b', 'E4', 'G4b'...
'G4', 'A4b', 'A4', 'B4b', 'B4', ...
'C5', 'D5', 'E5', 'F5', 'G5', ...
'A5', 'B5b', 'B5', 'C6'
};

freqs = [
261.625, 277.182, 293.664, 311.126, 329.627, 369.99, ...
391.995, 415.304, 440.000, 466.163, 493.883, ...
523.251, 587.329, 659.255, 698.456, 783.991, ...
880.000, 932.327, 987.766, 1046.502
];

% Octave pour autocorrélation
[~, idx] = min(abs(freqs - f0a));   % on prend l'indice qui correspond à la bonne fréquence
noteDetected1 = notes{idx};         % on prend la note qui correspond à l'indice

% Octave pour analyse spectrale
[~, idx] = min(abs(freqs - f0f));   % on prend l'indice qui correspond à la bonne fréquence
noteDetected2 = notes{idx};         % on prend la note qui correspond à l'indice

% Affichage des résultats
fprintf('\nMéthode autocorrélation:\n');
fprintf('Fréquence fondamentale : %.2f Hz\n', f0a);
fprintf('Note détectée : %s\n', noteDetected1);
fprintf('\nMéthode analyse spectrale:\n');
fprintf('Fréquence fondamentale : %.2f Hz\n', f0f);
fprintf('Note détectée : %s\n', noteDetected2);
fprintf('Fréquence haute : %.2f Hz\n',fh);
fprintf("Nombre d'harmoniques : %.f\n",nb_harmoniques);