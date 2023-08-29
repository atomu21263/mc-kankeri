#時間処理
scoreboard players remove *GameTimer Kankeri.System 1
##ティックを秒に
scoreboard players operation *TimerMin Kankeri.System = *GameTimer Kankeri.System
scoreboard players operation *TimerMin Kankeri.System /= *20 Kankeri.System
scoreboard players operation *TimerMin Kankeri.System /= *60 Kankeri.System
scoreboard players operation *TimerSec Kankeri.System = *GameTimer Kankeri.System
scoreboard players operation *TimerSec Kankeri.System /= *20 Kankeri.System
scoreboard players operation *TimerSec Kankeri.System %= *60 Kankeri.System
##ゼロパディング
execute if score *TimerSec Kankeri.System matches 10.. run data modify entity @e[type=armor_stand,tag=Kankeri.Can.Center,limit=1] CustomName set value '{"text":""}'
execute if score *TimerSec Kankeri.System matches ..9 run data modify entity @e[type=armor_stand,tag=Kankeri.Can.Center,limit=1] CustomName set value '{"text":"0"}'
##ボスバーにテキストを反映
execute if score *GameTimer Kankeri.System >= *TimerYellowTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"green","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り人数:"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"人"}]
execute if score *GameTimer Kankeri.System < *TimerYellowTick Kankeri.System run bossbar set kankeri:time color yellow
execute if score *GameTimer Kankeri.System < *TimerYellowTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"yellow","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り人数:"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"人"}]
execute if score *GameTimer Kankeri.System < *TimerRedTick Kankeri.System run bossbar set kankeri:time color red
execute if score *GameTimer Kankeri.System < *TimerRedTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"red","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り人数:"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"人"}]
##ボスバーに数値を反映
execute store result bossbar kankeri:time value run scoreboard players get *GameTimer Kankeri.System

#鬼
##束縛判定
execute if entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=!Kankeri.Can.Dropped] as @a[team=Kankeri.Player] at @s on attacker if entity @s[team=Kankeri.Hunter] as @p run function kankeri:system/bind
execute if entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] as @a[team=Kankeri.Player] at @s on attacker if entity @s[team=Kankeri.Hunter] as @p run effect give @s glowing 3 0 true
execute if entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] as @a[team=Kankeri.Player] at @s on attacker if entity @s[team=Kankeri.Hunter] as @p run effect give @s slowness 5 5 true
##勝利判定
execute unless entity @a[team=Kankeri.Player] run function kankeri:system/game/win_hunter
##PlayerFinder
execute as @a[team=Kankeri.Hunter,nbt={SelectedItem:{tag:{isPlayerFinder:1b}}}] at @s run function kankeri:system/player_finder
##円のマーカー
execute as @a[team=Kankeri.Hunter] at @s facing entity @e[type=armor_stand,tag=Kankeri.Can.Center] feet rotated ~ 0 run particle dust 1 0 1 0.2 ^ ^0.5 ^1.5 0 0 0 0 10 force @s
#子
##勝利判定
execute if score *GameTimer Kankeri.System matches 0 run function kankeri:system/game/win_player
##拘束処理
execute as @a[team=Kankeri.Player.Bind] at @s unless entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..3] run tp @s @e[type=armor_stand,tag=Kankeri.Can.Center,limit=1]
execute as @a[team=Kankeri.Player.Bind] run effect give @s mining_fatigue 1 127 true
execute as @a[team=Kankeri.Player.Bind,gamemode=survival] run gamemode spectator
execute as @a[team=Kankeri.Player,gamemode=spectator] run gamemode survival
##もくもく
execute as @e[type=area_effect_cloud,nbt={Effects:[{Duration:400,Id:14}]}] at @s run particle minecraft:campfire_signal_smoke ~ ~ ~ 5 5 5 0 50 force @a
##缶がないとき攻撃力なし
execute if entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] run effect give @a[team=Kankeri.Player] weakness 1 127 true

#缶の判定
##蹴り
execute as @e[type=interaction,tag=Kankeri.Can.Interact] at @s unless data entity @s attack{timestamp:0L} on attacker if entity @s[team=Kankeri.Hunter] at @s rotated ~ ~-50 run function kankeri:system/can/motion
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=!Kankeri.Can.Dropped] at @s if entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..10] unless data entity @s attack{timestamp:0L} on attacker if entity @s[team=Kankeri.Player] at @s rotated ~ ~-30 run function kankeri:system/can/motion
execute as @e[type=interaction,tag=Kankeri.Can.Interact] at @s unless data entity @s attack{timestamp:0L} run data modify entity @s attack.timestamp set value 0L
##子の脱出判定
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=!Kankeri.Can.Dropped] at @s unless entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..2] on attacker run tellraw @a [{"selector":"@s"},{"text":  " は 缶 を 蹴り飛ばした!"}]
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=!Kankeri.Can.Dropped] at @s unless entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..2] run team join Kankeri.Player @a[team=Kankeri.Player.Bind]
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=!Kankeri.Can.Dropped] at @s unless entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..2] run tag @s add Kankeri.Can.Dropped
##缶の戻し判定
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] at @s if entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..2] on attacker run tellraw @a [{"selector":"@s"},{"text":  " は 缶 を 元に戻した!"}]
execute as @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] at @s if entity @e[type=armor_stand,tag=Kankeri.Can.Center,distance=..2] run tag @s remove Kankeri.Can.Dropped
##缶の状態通知
execute if entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] run title @a[team=Kankeri.Hunter] actionbar {"text": "缶が円外にでている!","color": "red","bold": true}
execute unless entity @e[type=interaction,tag=Kankeri.Can.Interact,tag=Kankeri.Can.Dropped] run title @a[team=Kankeri.Player] actionbar {"text": "缶が円内にある!","color": "red","bold": true}
