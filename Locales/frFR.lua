local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "frFR")
if not L then return end
-- Core.lua
L["%s enabled"] = "%s activé" -- "<boss> enabled"
L["%s has been defeated"] = "%s a été vaincu(e)" -- "<boss> has been defeated"
L["%s have been defeated"] = "%s ont été vaincu(e)s" -- "<bosses> have been defeated"
L["Bosses"] = "Boss"
L["Options for bosses in %s."] = "Options concernant les boss |2 %s." -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "Options concernant %s (r%d)." -- "Options for <boss> (<revision>)"
L["Plugins"] = "Plugins"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Les plugins s'occupent des composants centraux de Big Wigs - comme l'affichage des messages, les barres temporelles, ainsi que d'autres composants essentiels."
L["Extras"] = "Extras"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Les extras sont des plugins tiers et incorporés dont Big Wigs peut se passer pour fonctionner correctement."
L["Active"] = "Actif"
L["Activate or deactivate this module."] = "Active ou désactive ce module."
L["Reboot"] = "Redémarrer"
L["Reboot this module."] = "Redémarre ce module."
L["Options"] = "Options"
L["Minimap icon"] = "Icône de la minicarte"
L["Toggle show/hide of the minimap icon."] = "Affiche ou non l'icône sur la minicarte."
L["Advanced"] = "Avancés"
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "Vous n'avez normalement pas besoin de toucher à ces options, mais si vous voulez les peaufinez, n'hésitez pas !"

L["Toggles whether or not the boss module should warn about %s."] = "Autorise ou non le module de boss d'afficher des barres temporelles et/ou des alertes concernant %s."
L.bosskill = "Défaite du boss"
L.bosskill_desc = "Prévient quand le boss est vaincu."
L.berserk = "Berserk"
L.berserk_desc = "Prévient quand le boss devient fou furieux via une barre temporelle et des messages réguliers."

L["Load"] = "Charger"
L["Load All"] = "Tout charger"
L["Load all %s modules."] = "Charge tous les modules |2 %s."

L.already_registered = "|cffff0000ATTENTION :|r |cff00ff00%s|r (|cffffff00%s|r) existe déjà en tant que module dans Big Wigs, mais quelque chose essaye de l'enregistrer à nouveau. Cela signifie souvent que vous avez deux copies de ce module dans votre répertoire AddOns suite à une mauvaise mise à jour d'un gestionnaire d'addons. Il est recommandé de supprimer tous les répertoires de Big Wigs et de le réinstaller complètement."

-- Loader / Options.lua
L["You are running an official release of Big Wigs 3.0 (revision %d)"] = "Vous utilisez une version FINALISÉE de BW 3.0 (r%d)."
L["You are running an ALPHA RELEASE of Big Wigs 3.0 (revision %d)"] = "Vous utilisez une version ALPHA de BW 3.0 (r%d)."
L["You are running a source checkout of Big Wigs 3.0 directly from the repository."] = "Vous utilisez une version du dépôt de BW 3.0."
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "Une nouvelle version de Big Wigs est disponible. Vous pouvez visiter curse.com, wowinterface.com, wowace.com ou utiliser le Curse Updater pour obtenir cette nouvelle version."

L["|cff00ff00Module running|r"] = "|cff00ff00Module actif|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55fClic gauche|r pour redémarrer les modules actifs. |cffeda55fAlt-Clic gauche|r pour les désactiver. |cffeda55fCtrl-Alt-Clic gauche|r pour désactiver complètement Big Wigs."
L["Active boss modules:"] = "Modules de boss actifs :"
L["All running modules have been reset."] = "Tous les modules actifs ont été réinitialisés."
L["Menu"] = "Menu"
L["Menu options."] = "Options du menu."

L["Big Wigs is currently disabled."] = "Big Wigs est actuellement désactivé."
L["|cffeda55fClick|r to enable."] = "|cffeda55fCliquez|r pour l'activer."
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fCliquez|r pour réinitialiser tous les modules actifs. |cffeda55fAlt-clic gauche|r pour les désactiver. |cffeda55fCtrl-Alt-clic gauche|r pour désactiver complètement BigWigs."
L["All running modules have been disabled."] = "Tous les modules actifs ont été désactivés."

-- Options.lua
L["Customize ..."] = "Personnaliser..."
--L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = ""
L["Configure ..."] = "Configurer..."
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "Ferme la fenêtre des options de l'interface et vous permet de configurer l'affichage des barres et des messages.\n\nSi vous voulez personnaliser plus en profondeur le reste de Big Wigs, étendez l'arbre de configuration sur la gauche et cliquez sur \"Personnaliser...\"."
L["Sound"] = "Son"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "Les messages sont le plus souvent accompagnés de sons. Certaines personnes trouvent plus faciles d'entendre ces sons pour réagir une fois qu'ils ont appris quels sons sont liés à quels messages plutôt que de lire les messages à chaque fois.\n\n|cffff4411Même si ceci est décoché, le son par défaut de l'Avertissement raid risque de continuer à être jouer à cause des messages provenant des autres joueurs. Ce son est cependant différent de ceux que nous utilisons.|r"
L["Blizzard warnings"] = "Avertissements de Blizzard"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "Blizzard affiche ses propres messages pour certaines capacités dans certaines rencontres. À notre avis, ces messages sont trop long et trop descriptifs. Nous essayons de produire des messages plus courts et concis qui n'interfèrent pas avec votre manière de jouer et qui ne vous disent pas quoi faire à votre place.\n\n|cffff4411Quand cette case est décochée, les avertissements de Blizzard ne seront pas affichés au milieu de l'écran, mais seront toujours présents dans votre fenêtre de discussion.|r"
L["Raid icons"] = "Icônes de raid"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Certains scripts de rencontre utilisent des icônes pour marquer les joueurs affectés par des capacités précises. Par exemple, les effets de type \"bombe\" et les contrôles mentaux. Si vous décochez ceci, vous ne marquerez personne.\n\n|cffff4411Ne fonctionne que si vous êtes soit le chef du groupe (de raid), soit un de ses assistants !|r"
L["Whisper warnings"] = "Chuchoter les avertissements"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Envoye des chuchotements aux joueurs affectés par certaines capacités pendant les rencontres face aux boss. Pensez aux effets du type \"bombe\" et autres.\n\n|cffff4411Ne fonctionne que si vous êtes soit le chef du groupe (de raid), soit un de ses assistants !|r"
L["Broadcast"] = "Diffuser"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r"] = "Diffuse les messages de Big Wigs sur le canal Avertissement raid.\n\n|cffff4411Ne fonctionne que si vous êtes chef du raid ou dans un groupe !|r"
L["Raid channel"] = "Canal Raid"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "Utilise le canal Raid au lieu de l'Avertissement raid pour la diffusion des messages."
L["|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44"] = "|cffccccccLes élans n'aiment pas être piqués avec des bâtons pointus.\nContactez nous sur irc.freenode.net/#wowace. [Ammo] et vhaarr peuvent vous aider (parlez en anglais !).|r\n|cff44ff44"
L["Configure"] = "Configuration"
L["Test"] = "Test"
L["Reset positions"] = "Réinitialiser les positions"
L["Options for %s."] = "Options concernant %s."

L["BAR"] = "Barres"
L["MESSAGE"] = "Messages"
L["SOUND"] = "Sons"
L["ICON"] = "Icône"
L["PROXIMITY"] = "Proximité"
L["WHISPER"] = "Chuchoter"
L["SAY"] = "Dire"
L["FLASHSHAKE"] = "Flash'n'shake"
L["PING"] = "Ping"