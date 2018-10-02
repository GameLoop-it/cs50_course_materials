# CS50 Third Assignment! Breakout

- [x] Add a Powerup class to the game that spawns a powerup (images located at the bottom of the sprite sheet in the distribution code). This Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and gradually descend toward the player. Once collided with the Paddle, two more Balls should spawn and behave identically to the original, including all collision and scoring points for the player. Once the player wins and proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again.

- [x] Grow and shrink the Paddle such that it’s no longer just one fixed size forever. In particular, the Paddle should shrink if the player loses a heart (but no smaller of course than the smallest paddle size) and should grow if the player exceeds a certain amount of score (but no larger than the largest Paddle). This may not make the game completely balanced once the Paddle is sufficiently large, but it will be a great way to get comfortable interacting with Quads and all of the tables we have allocated for them in main.lua!

- [x] Add a locked Brick (located in the sprite sheet) to the level spawning, as well as a key powerup (also in the sprite sheet). The locked Brick should not be breakable by the ball normally, unless they of course have the key Powerup! The key Powerup should spawn randomly just like the Ball Powerup and descend toward the bottom of the screen just the same, where the Paddle has the chance to collide with it and pick it up. You’ll need to take a closer look at the LevelMaker class to see how we could implement the locked Brick into the level generation. Not every level needs to have locked Bricks; just include them occasionally! Perhaps make them worth a lot more points as well in order to compel their design. Note that this feature will require changes to several parts of the code, including even splitting up the sprite sheet into Bricks!


<hr>

* [ ] __"Attractor"__: riconosciuto da tutte le sale giochi del mondo come il powerup piu' potente di Arknoid, una volta raccolto l'attractor fa apparire una sorta di "glow" (o campo elettrico o altro) attorno alla racchetta. A questo punto, quando si tocca una pallina, essa rimane attaccata alla racchetta fino a che il giocatore non decide di respingerla.
Implementate una versione dell'attractor che:
    * Una volta attivo, "incolli" le palline solo se esse toccano la racchetta quando un certo tasto e' premuto (tipo freccia in su)
    * Quando si lascia il tasto, se ci sono delle palline incollate, esse vengono rilasciate
    * La direzione di rilascio dipende da dove si trova il cursore del mouse: la palla viaggia verso quel punto
_Nota: l'attractor deve funzionare anche col multiball - in qualche modo._

* [ ] "I'm the firestarter": potevamo farci mancare una trappola da bestemmie vere? Implementate lo spawn casuale di un "qualcosa" (decidete voi cosa), alto come un mattone e largo la meta', che fino a che si trovera' sul campo sparera' ad intervalli regolari delle fireball nella direzione della racchetta. Toccare una fireball significa morte immediata! La trappola dovra reagire alle collisioni come un blocco e potra' sparire dopo un tot di colpi o di tempo. Bonus per chi fa lo sparo particolarmente infame - comunque vogliate!
_Specifiche: ad ogni generazione di un livello, calcolate un valore S = math.random(30, 60). Ogni S rimbalzi, in quel livello, comparira' la torretta. Un rimbalzo si conta quando la racchetta tocca una pallina, o quando la racchetta muore (no palline). La torretta muore dopo 10 rimbalzi, o dopo essere stata colpita 5 volte._
__WARNING__: i parametri sopra potrebbero essere aggiustati in futuro.

* "AI is Back": Sfida "semplice": create una AI per il gioco. E ok.
Ma non finisce qui: non sarebbe bello avere una bella compo tra chi "ce l'ha migliore"? Si puo' fare facilmente se:

    * Rendete il generatore di livelli dipendente da un valore "seed" dato in input. A questo punto, il valore "123" generera' per tutti la stessa sequenza di livelli
    * Implementate un contatore di quanto passa tra l'inizio e la fine di un livello, in secondi