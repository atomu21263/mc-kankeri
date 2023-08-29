#時間管理
##秒を時間に
scoreboard players operation *GameTimer Kankeri.System = *GameTimeSec Kankeri.System
scoreboard players operation *GameTimer Kankeri.System *= *20 Kankeri.System
##ボスバー
execute store result bossbar kankeri:time max run scoreboard players get *GameTimer Kankeri.System
bossbar set kankeri:time color green
bossbar set kankeri:time players @a

#プレイヤー関連
##チーム割り当て
function kankeri:system/game/team
##リセット
clear @a[team=Kankeri.Hunter]
clear @a[team=Kankeri.Player]

#子 関連
##アイテム
give @a[team=Kankeri.Player] stick{display:{Name:'{"text": "のっくばっく すてぃっく","color":"gold","bold": true,"italic": false}'},Enchantments:[{id:"minecraft:knockback",lvl:5s}]} 1
give @a[team=Kankeri.Player] dried_kelp 64
give @a[team=Kankeri.Player] lingering_potion{display:{Name:'{"text": "もくもく","color":"gray","bold": true,"italic": false}'},CustomPotionEffects:[{Id:14,Amplifier:0b,Duration:400,ShowParticles:false}],CustomPotionColor:0} 5
##エフェクト
effect give @a[team=Kankeri.Player] minecraft:saturation 1 127
effect give @a[team=Kankeri.Player] mining_fatigue 60 127 true
effect give @a[team=Kankeri.Player] resistance infinite 127 true

#鬼 関連
##エフェクト
effect give @a[team=Kankeri.Hunter] minecraft:saturation 1 127
effect give @a[team=Kankeri.Hunter] blindness 10 0 true
effect give @a[team=Kankeri.Hunter] weakness 10 127 true
effect give @a[team=Kankeri.Hunter] resistance infinite 127 true
effect give @a[team=Kankeri.Hunter] speed infinite 2 true
##アイテム
loot give @a[team=Kankeri.Hunter] loot kankeri:player_finder
give @a[team=Kankeri.Hunter] stick{display:{Name:'{"text": "ノックバック スティック","color":"gold","bold": true,"italic": false}'},Enchantments:[{id:"minecraft:knockback",lvl:10s}]} 1
give @a[team=Kankeri.Hunter] bow{Unbreakable:1b,Enchantments:[{id:"minecraft:infinity",lvl:1s}]}
give @a[team=Kankeri.Hunter] arrow 1
give @a[team=Kankeri.Hunter] red_stained_glass 512
give @a[team=Kankeri.Hunter] dried_kelp 64
item replace entity @a[team=Kankeri.Hunter] armor.feet with diamond_boots{Enchantments:[{id:"minecraft:frost_walker",lvl:1s}]} 1
#全体処理
##TP
tp @a[team=Kankeri.Hunter] @e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]
tp @a[team=Kankeri.Player] @e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]
##ゲームモード
gamemode survival @a[team=Kankeri.Hunter]
gamemode survival @a[team=Kankeri.Player]
##ワールド
time set day
weather clear
##缶を飛ばす
execute at @e[type=armor_stand,tag=Kankeri.Can.Center] facing entity @e[sort=random,limit=1] feet rotated ~ -50 run function kankeri:system/can/motion