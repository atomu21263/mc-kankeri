#通知
tellraw @a {"text":"Kankeri Datapack Is Loaded"}
tellraw @a {"text":"Main Creator  : @atomu21263"}
tellraw @a {"text":"Commands,Rule : Check For Advancement."}


#スコアボード
scoreboard objectives add Kankeri.System dummy
scoreboard players set *20 Kankeri.System 20
scoreboard players set *60 Kankeri.System 60

scoreboard players set *Hunter Kankeri.System 4
scoreboard players set *HunterCount Kankeri.System 0

scoreboard players add *IsCanPlaced Kankeri.System 0

scoreboard players set *CountDown Kankeri.System -1
scoreboard players set *GameTimeSec Kankeri.System 600
scoreboard players set *GameTimer Kankeri.System -1

scoreboard players set *TimerYellowTick Kankeri.System 6000
scoreboard players set *TimerRedTick Kankeri.System 1200
scoreboard players set *TimerMin Kankeri.System 0
scoreboard players set *TimerSec Kankeri.System 0

scoreboard objectives add Kankeri.Number dummy
scoreboard players add *Now Kankeri.Number 0


#チーム
team remove Kankeri.Hunter
team add Kankeri.Hunter "鬼"
team modify Kankeri.Hunter color red
team modify Kankeri.Hunter friendlyFire false

team remove Kankeri.Player
team add Kankeri.Player "子"
team modify Kankeri.Player color green
team modify Kankeri.Player friendlyFire false


#ボスバー
bossbar remove kankeri:time
bossbar add kankeri:time ""