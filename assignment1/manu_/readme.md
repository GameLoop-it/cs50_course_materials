# CS50 Assignment 1

- [x] Randomize the gap between pipes (vertical space), such that they’re no longer hardcoded to 90 pixels.

- [x] Randomize the interval at which pairs of pipes spawn, such that they’re no longer always 2 seconds apart.

- [x] When a player enters the ScoreState, award them a “medal” via an image displayed along with the score; this can be any image or any type of medal you choose (e.g., ribbons, actual medals, trophies, etc.), so long as each is different and based on the points they scored that life. Choose 3 different ones, as well as the minimum score needed for each one (though make it fair and not too hard to test :)).

- [x] Implement a pause feature, such that the user can simply press “P” (or some other key) and pause the state of the game. This pause effect will be slightly fancier than the pause feature we showed in class, though not ultimately that much different. When they pause the game, a simple sound effect should play (I recommend testing out bfxr for this, as seen in Lecture 0!). At the same time this sound effect plays, the music should pause, and once the user presses P again, the gameplay and the music should resume just as they were! To cap it off, display a pause icon in the middle of the screen, nice and large, so as to make it clear the game is paused.

# Gameloop50 Hard Mode Challenges - sponsored by Wintermute 

* [x] TRC*: Il gioco come e' fornito ha un bug clamoroso che lo rovina. Trovatelo, e fixatelo. Facile!

* [ ] Extra lives: non so voi ma a me Flappy Bird ha sempre fatto schifo, morire subito sara' divertente per il restante 90% del pianeta ma non per me, perche' non aggiungere delle vite extra?
All'inizio del gioco, il giocatore ha 2 vite extra, mostrate da 2 sprites (tipo http://pixelartmaker.com/art/2ef286e85b00823) disegnati in alto. Quando si colpisce un ostacolo l'uccellino deve
   * Morire se non ha piu' cuori (= vite), altrimenti
   * Perdere una vita
   * Attivare una modalita' "invincibile" che dura 2 secondi e durante la quale lo sprite "flickera" (tipo giochi old school)
   
* [ ] Chicanes!: chi vuole qualche tracciato piu' divertente? Modificate la generazione dei tubi per permettere la generazione di chicanes tipo: 
    ![chicanes](https://sketch.io/render/sk-b8fa7268e13a91db9ae1b1beb98fd1cd.jpeg)


  * Le chicanes possono essere lunghe quanto volete, con i parametri che volete, possono apparire a random durante le partite o alla pressione di un tasto, fate voi!
