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
execute if score *TimerSec Kankeri.System matches 10.. run data modify entity @e[type=armor_stand,tag=Kankeri.Can.Master,limit=1] CustomName set value '{"text":""}'
execute if score *TimerSec Kankeri.System matches ..9 run data modify entity @e[type=armor_stand,tag=Kankeri.Can.Master,limit=1] CustomName set value '{"text":"0"}'
##ボスバーにテキストを反映
execute if score *GameTimer Kankeri.System >= *TimerYellowTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"green","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Master,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り:"},{"score":{"name": "*KickCount","objective": "Kankeri.System"}},{"text": "/"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"回"}]
execute if score *GameTimer Kankeri.System < *TimerYellowTick Kankeri.System run bossbar set kankeri:time color yellow
execute if score *GameTimer Kankeri.System < *TimerYellowTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"yellow","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Master,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り:"},{"score":{"name": "*KickCount","objective": "Kankeri.System"}},{"text": "/"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"回"}]
execute if score *GameTimer Kankeri.System < *TimerRedTick Kankeri.System run bossbar set kankeri:time color red
execute if score *GameTimer Kankeri.System < *TimerRedTick Kankeri.System run bossbar set kankeri:time name [{"text":"","color":"red","bold": true},{"text":"残り時間 "},{"score":{"name": "*TimerMin","objective": "Kankeri.System"}},{"text":":"},{"selector":"@e[type=armor_stand,tag=Kankeri.Can.Master,limit=1]"},{"score":{"name": "*TimerSec","objective": "Kankeri.System"}},{"text":" 残り:"},{"score":{"name": "*KickCount","objective": "Kankeri.System"}},{"text": "/"},{"score":{"name": "*PlayerCount","objective": "Kankeri.System"}},{"text":"回"}]
##ボスバーに数値を反映
execute store result bossbar kankeri:time value run scoreboard players get *GameTimer Kankeri.System

#鬼
##束縛判定
execute as @a[team=Kankeri.Player,gamemode=survival,nbt={HurtTime:8s}] at @s on attacker if entity @s[team=Kankeri.Hunter] as @p run function kankeri:system/bind
##勝利判定
execute if score *GameTimer Kankeri.System matches 0 run function kankeri:system/game/win_hunter
execute unless entity @a[team=Kankeri.Player,gamemode=survival] run function kankeri:system/game/win_hunter
##PlayerFinder
execute as @a[team=Kankeri.Hunter,nbt={SelectedItem:{tag:{isPlayerFinder:1b}}}] at @s run function kankeri:system/player_finder
##缶のマーカー
execute as @a[team=Kankeri.Hunter] at @s facing entity @e[type=armor_stand,tag=Kankeri.Can.Master] feet rotated ~ 0 run particle dust 1 0 1 0.2 ^ ^0.5 ^1.5 0 0 0 0 10 force @s
#子
##勝利判定
execute if score *KickCount Kankeri.System = *PlayerCount Kankeri.System run function kankeri:system/game/win_player
##もくもく
execute as @e[type=area_effect_cloud,nbt={Effects:[{Duration:400,Id:14}]}] at @s run particle minecraft:campfire_signal_smoke ~ ~ ~ 3 3 3 0 10 force @a

#缶の処理
##無効化
execute if score *KickIgnore Kankeri.System matches 1.. run scoreboard players remove *KickIgnore Kankeri.System 1
##蹴り
execute as @a[team=Kankeri.Player,predicate=kankeri:sneak] at @s if entity @e[type=armor_stand,tag=Kankeri.Can.Master,distance=..1] run function kankeri:system/can/check
##通知
execute if score *KickIgnore Kankeri.System matches 0 as @e[type=item_display,tag=Kankeri.Can.Display] at @s on vehicle positioned as @s run particle dust 1 0 0 0.5 ^ ^0.1 ^1 0 0 0 0 10 force @a[team=Kankeri.Player]
execute if score *KickIgnore Kankeri.System matches 0 as @e[type=item_display,tag=Kankeri.Can.Display] at @s on vehicle positioned as @s rotated ~180 ~ run particle dust 1 0 0 0.5 ^ ^0.1 ^1 0 0 0 0 10 force @a[team=Kankeri.Player]
execute if score *KickIgnore Kankeri.System matches 0 run title @a[team=Kankeri.Player] actionbar {"text":"缶をけりに行け!","color":"green","bold":true}
execute if score *KickIgnore Kankeri.System matches 1.. run title @a[team=Kankeri.Player] actionbar [{"text":"缶を蹴れるまで残り ","color":"red","bold":true},{"score":{"name": "*KickIgnore","objective": "Kankeri.System"}}]
