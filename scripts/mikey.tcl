##################################################
## mikey.tcl (aka Zephyr)
## 
## Collection of public and private commands which
## make up the workings of the bot, Zephyr.
##################################################

# bind <type> <flags> <match> <proc name>
bind join - * join:join
bind pub - !msg s_msg
bind pub - !say s_msg
bind pub - !tell s_msg
bind pub - !act s_act
bind pub - !bin s_bin
bind pub - !rickroll rickroll
bind pub - Zephyr s_zephyr
bind pub - tribes pub_tribes
bind pub - !join s_join
bind pub - !invite s_invite
# Staff Only Commands
bind pub o !part s_part
bind pub o !regchan s_regchan
bind pub o !topic s_topic
bind pub o !appendtopic s_appendtopic
bind pub o !rehash s_rehash
bind pub o !up s_up

set greetings {
	"hello"
	"hi"
	"hey"
	"howdy"
	"what's up"
	"sup"
	"hola"		
	"bonjour"
}

set passwords {
	"KJGOuyf8DF^*"
	"KJHDITs57s7uky"
	"lUGOUFO*&"
	"878456468t79"
	"LIOUt87FLIU"
	"4OJPI56OUVJK6"
	"4566546456645644565"		
	"OYFOYUDuyclvjhVKLUYDvhv"
}

set z_greets {
	"You Rang?"
	"So tell me something already"
	"That's my name!"
	"How can I help?"
	"What's the story?"
}


foreach greeting $greetings { bind pub - $greeting s_hello }

proc join:join {nick uhost handle chan} {
	global greetings
	array set bannedChans {
		1 "#gamefront"
		2 "#welcome"
	}
			if {$nick != "Zephyr"} {
				if {$nick == "Serio"} { 
					putserv "PRIVMSG $chan :Serio! <3"
				} elseif {$chan != "#gamefront"} { 
			  		putserv "PRIVMSG $chan :[lindex $greetings [rand [llength $greetings]]] $nick"
			  	}
		  	}
			#putlog "Said Hello to $nick (ONJOIN) $chan"
			if {$nick == "Mikey"} {
				pushmode $chan +q $nick
				pushmode $chan +a $nick
				pushmode $chan +o $nick
				pushmode $chan +h $nick
				pushmode $chan +v $nick
			} else {
				pushmode $chan +v $nick
			}
			putlog "Voiced $nick on $chan (ONJOIN)"
}

proc s_hello {nick host handle chan text} {
	global greetings
	putquick "PRIVMSG $chan :[lindex $greetings [rand [llength $greetings]]] $nick"
  	putlog "Said Hello to $nick"
}

proc s_msg {nick uhost hand chan text} {       
     set where [lindex [join $text] 0] 
     set what [join [lrange [split $text] 1 end]] 
     putquick "PRIVMSG $where :$what" 
} 

proc s_zephyr {nick uhost hand chan text} {
	global z_greets
	if {$chan != "#ircrpg"} {
		if {$nick == "Serio"} {
			putquick "PRIVMSG $chan :Serio! <3"
		} elseif {$nick == "mika"} {
			putquick "PRIVMSG $chan :I don't ignore you, mika. I promise."
		} else {
			putquick "PRIVMSG $chan :[lindex $z_greets [rand [llength $z_greets]]]"
		}
	}
}

proc s_up {nick uhost hand chan text} {
	if  {$nick == "Mikey"} {
		pushmode $chan +q $nick
		pushmode $chan +a $nick
		pushmode $chan +o $nick
		pushmode $chan +h $nick
		pushmode $chan +v $nick
	} else {
		putquick "PRIVMSG $chan :No."
	}
}

proc s_join {nick uhost hand chan text} {
	if {$text == "#welcome"} {
		if {$nick != "Mikey"} {
			putquick "PRIVMSG $chan : I'm not allowed to join #welcome without permission, $nick." 
		} else {
			putquick "PRIVMSG $chan : Only joining #welcome because you've told me to, $nick."
			channel add $text
       		savechannels
			#putquick "JOIN $text"
			putlog "joined $text"
		}
	} else {
		channel add $text
        savechannels
		#putquick "JOIN $text"
		putlog "joined $text"
	}
} 

proc s_part {nick uhost hand chan text} {
		channel remove $text
  		savechannels
		#putquick "PART $text"
		putlog "parted $text"
} 

proc s_invite {nick uhost hand chan text} {
		putquick "INVITE $text $chan"
		putlog "invited $text"
} 

proc s_act {nick uhost hand chan text} { 
     putquick "PRIVMSG $chan :\001ACTION $text" 
}

proc s_bin {nick uhost hand chan text} { 
     putquick "PRIVMSG $chan :$nick try http://pastebin.com / http://bin.cakephp.org/add/$nick / http://privatepaste.com / http://bin.mikeylicio.us" 
} 

proc rickroll {nick uhost hand chan text} {
	array set rolls {
		1 "We're no strangers to love"
		2 "You know the rules and so do I"
		3 "A full commitment's what I'm thinking of"
		4 "You wouldn't get this from any other guy"
		5 "I just wanna tell you how I'm feeling"
		6 "Gotta make you understand"
		7 "Never gonna give you up"
		8 "Never gonna let you down"
		9 "Never gonna run around and desert you"
		10 "Never gonna make you cry"
		11 "Never gonna say goodbye"
		12 "Never gonna tell a lie and hurt you"
	}
	foreach {n t} [array get rolls] {
	    putquick "PRIVMSG $chan :$t"
	}
	putlog	"$chan rickroll'd"
}

proc s_regchan {nick uhost hand chan text} {
	global passwords
    putserv "PRIVMSG ChanServ :REGISTER $chan [lindex $passwords [rand [llength $passwords]]] This is a channel registered by Zephyr."
    putserv "PRIVMSG Mikey :Registered $chan with password [lindex $passwords [rand [llength $passwords]]]" 
    putlog "Registered $chan with password [lindex $passwords [rand [llength $passwords]]]"
}

proc s_topic {nick uhost hand chan text} {
	putserv "PRIVMSG ChanServ :TOPIC $chan $text"
    putlog "Updated topic for $chan to $text"
}

proc s_appendtopic {nick uhost hand chan text} {
	putserv "PRIVMSG ChanServ :APPENDTOPIC $chan $text"
    putlog "Updated topic for $chan with $text"
}

proc s_rehash {nick uhost hand chan text} {
	rehash
	putquick "PRIVMSG #winning :rehashing"
    putlog "rehashing"
}

putlog "Mikey.tcl loaded"

proc pub_tribes {nick mask hand channel args} {

	putquick "PRIVMSG $channel :$nick: this irc network is not tribes-related at all, you've ended up in the wrong place. you won't find any tribes-related channels here. please update your game to connect to the tribes chatroom. (Your connection may be closed.)"
	if {$nick != "Mikey"} {
	putserv "BAN $channel $nick Murdered."
	}
	putserv "KICK $channel $nick Murdered."
}

