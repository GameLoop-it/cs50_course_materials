# CS50 - Course materials

<p align="center">
  <img src="https://gameloop.it/wp-content/uploads/2018/03/qjNWU6o.png">
</p>

La community di Gameloop sta seguendo il corso creato dal team del CS50 per imparare a sviluppare videogiochi.

Siamo attivi su:
- [Discord](https://discord.gg/VzVMpFq): abbiamo un canale dedicato a chi segue il corso
- [Forum](https://forum.gameloop.it/d/449-gameloop50-seguiamo-il-cs50-insieme-impariamo-a-sviluppare-videogiochi/): discussione di riferimento con link, consigli e sfide aggiuntive
- [Twitch](https://www.twitch.tv/videos/283930553): live coding degli assignment

## Cos'è il C5S0?
Il [CS50](https://en.wikipedia.org/wiki/CS50) (Computer Science 50) è un corso di introduzione all'informatica offerto inizialmente dall'università di Harvard, sia "on campus" che online. In seguito, lo stesso team di Harvard ne ha creato una versione ["gamedev"](https://cs50.github.io/games/), che mostra le basi della programmazione di videogames e include sessioni "hands on" sul codice di alcuni clone di Pong, Flappy Bird, Breakout, Super Mario, Pokemon, Zelda, ecc.

## Che tecnologie si usano?
**Lua**, **Love2D** e **Unity 3D**.

## Perché seguire il corso con Gameloop?
Perché insieme possiamo condividere i nostri problemi e soluzioni ed apprendere molto di più. 
Oltretutto molti utenti di Gameloop sono pronti a fornire supporto e a condividere la loro esperienza!

Inoltre, non ci limitiamo solo a seguire il corso, abbiamo creato anche una **hard mode**, ovvero delle sfide aggiuntive, curate dal nostro caro [*Wintermute*](https://twitter.com/winterismute), che potete trovare sul [nostro forum](https://forum.gameloop.it/d/449-gameloop50-seguiamo-il-cs50-insieme-impariamo-a-sviluppare-videogiochi/)!

## Cos'è questo repository?
Una collezione di tutti gli assignment del CS50 che sono stati creati dagli utenti di [Gameloop.it](https://gameloop.it/).  
Sarà un ricordo per chi ha partecipato ed una risorsa per chi affronterà il corso in un secondo momento.

## Voglio seguire il corso, cosa devo fare?
Per qualsiasi dubbio fate un salto sul [forum](https://forum.gameloop.it/d/449-gameloop50-seguiamo-il-cs50-insieme-impariamo-a-sviluppare-videogiochi/) o sul canale dedicato su [Discord](https://discord.gg/VzVMpFq) dove siamo **molto** attivi.

---

# Assignment sviluppati

## 0 - Pong
<p align="center">
  <img width="60%" src="https://imgur.com/cZh22IN.png">
</p>

- Attributi degli oggetti e loro manipolazione (posizione e velocità)
- RNG
- IA semplice
- Collisioni AABB
  
## 1 - Flappy bird
<p align="center">
  <img width="60%" src="https://imgur.com/CuC9SQq.png">
</p>

- Sprites
- Generazione random del livello
- States
- Background scrolling
- Meccaniche dei powerup


## 2 - Breakout
<p align="center">
  <img width="60%" src="https://imgur.com/qAKY0FV.png">
</p>

- Spritesheet
- Particle Effects
- Organizzazione codice 
- Salvare i punteggi


## 3 - Match 3
<p align="center">
  <img width="60%" src="https://imgur.com/vC0b29s.png">
</p>

- Meccaniche puzzle game
- Grid based system
- Tween
- Libreria Lua Knife


## 4 - Super Mario Bros
<p align="center">
  <img width="60%" src="https://imgur.com/hBTEyIN.png">
</p>

- Meccaniche platformer 2D a scorrimento laterale
- Generazione random della TileMap del livello
- Collisioni con callback
- Nemici con semplice IA


## 5 - Zelda
<p align="center">
  <img width="60%" src="https://i.imgur.com/pGv0rcS.png">
</p>

- Prospettiva *top-down 2D*
- *Generazione dungeon infinito* (oppure generazione dungeon da file CSV per l'hard mode)
- *Sreen Scrolling* per le transizioni della camera tra una stanza e l'altra del dungeon
- *Hitbox* e *Hurtbox*
- *Data driven programming* per generare le entità (i nemici) e gli oggetti di gioco
- Eventi con `Events.dispatch()`, `Events.on()`

## 6 - Angry Birds
<p align="center">
  <img width="60%" src="https://imgur.com/yPupbWM.png">
</p>

- Simulazione fisica con Box2D
- Mouse input

## 7 - Pokemon
<p align="center">
  <img width="60%" src="https://imgur.com/hWJvg3g.png">
</p>

- State stack
- Turn based system
- GUI
- Meccaniche RPG

## 8 - Helicopter 3D
<p align="center">
  <img width="60%" src="https://imgur.com/loQ8OpC.png">
</p>

- Unity 3D: Game Object, C#, MonoBehaviour, Co-routine e `yield return`
- Gioco scorrimento laterale in 3D (Gameplay 2.5D)

## 9 - Dreadhalls (Unity3D e Blender)
<p align="center">
  <img width="60%" src="https://imgur.com/kNeQcwR.png">
</p>

- Texturing
- Materials and lightning
- 3D Maze generation
- First Person Controllers
- Multiple Scenes
- Fog
- UI Components and Unity 2D

## 10 - Portal (Unity3D e Blender)
<p align="center">
  <img width="60%" src="https://imgur.com/WqseaAq.png">
</p>

- ProBuilder & ProGrids
- Raycasting
- RenderTexture
- Texture Masking
- Teleporting
