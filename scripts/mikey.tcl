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
bind pub - !batman pub_batman
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

proc pub_batman {nick mask hand channel args} {
   global batman
   puthelp "PRIVMSG $channel :[lindex $batman [rand [llength $batman]]]"
}

proc pub_tribes {nick mask hand channel args} {

	putquick "PRIVMSG $channel :$nick: this irc network is not tribes-related at all, you've ended up in the wrong place. you won't find any tribes-related channels here. please update your game to connect to the tribes chatroom. (Your connection may be closed.)"
	if {$nick != "Mikey"} {
	putserv "BAN $channel $nick Murdered."
	}
	putserv "KICK $channel $nick Murdered."
}

set batman {

"\"Batman has over 10,000 books in his house.  Every single one of them states over 10,000 facts why Batman is awesome.\""
              	
"\"The Batmobile is black because Batman couldn't get it in a darker color.\""

"\"uperman sleeps with a Batman plushie to scare off nightmares since he couldn't get Batman to sleep with him in his apartment in Metropolis.\""
              	
"\"Batman COULD be President of the United States.  It's just that he refuses to live in a white house.\""
              	
"\"Batman once caused Mr. Freeze to make Yellow Snow.\""
              	
"\"After what Batman did to The Penguin, real penguins decided to move to Antartica - just in case....\""
              	
"\"There's no where you can run that Batman can't find you.  The Flash knows.  He tried.\""
              
"\"Only one person has ever been known to answer the `Who would win in a fight - Batman or Superman? question with `Superman`.\""

"\"Batman didn't enjoy hurting Martha Kent, but examples must be made.\""
              	
"\"Batman was happier in the sixties. There may have been drugs involved.\""
              	
"\"Batman does not use hair product.  His hair does what it is told.\""
              	
"\"The batmobile drives so fast as an attempt to get away from Batman. Batman just steers.\""
              	
"\"Batman knows both The Question and the answer.\""
              	
"\"Chuck Norris only comes out during the day, because Batman comes out at night.\""
              	
"\"Batman just may need to smek a bitch.\""
              	
"\"Batman doesn't kill. He prefers to make people wish they were dead.\""
              	
"\"Batman's jet has a thousand buttons, each of which do something different, including but not limited to time travel. None of them are labeled.\""
            
"\"Batman isn't a creature of the night. The night approaches Batman carefully avoiding any eye contact.\""
              	
"\"Batman doesn't read books, he just stares them down 'till he gets the information he needs from them.\""
              
"\"Q: Pirates vs. ninjas? A: Batman.\""

"\"Batman does not really have a kryptonite ring. It's made of apple-flavored candy. He just intimidates Superman into losing his powers and feeling deathly ill.\""
              	
"\"If Batman where a candy, his flavor would be DARKNESS.\"" 
              	
"\"Death is scared of the Batman. That's why he gave back Jason Todd.\""
              	
"\"Batman knows that somedays you just can't get rid of a bomb...\""
              	
"\"Technically Batman is with Catwoman, but he likes a little Dick on the side.\""
              	
"\"Batman is bringing sexy back.\""
              	
"\"Batman knows what you did.\""
              	
"\"Batman is the only living person who is known to have deflected Chuck Norris' roundhouse kick.\""
              	
"\"Robin isn't a partner, he's a distraction. That's why Batman has him wearing the bright colours.\""
              	
"\"The rest of the Justice League refuses to play Clue with Batman.\""
              	
"\"The Joker doesn't hate Batman.\""

"\"The Joker wishes he knew how to quit.\""

"\"Robin: Batman, maybe I should stay home tonight, Homework, you know Batman,I think you should acquire a taste fore opera, Robin, as one does fore poetry andolives.\""


"\"Robin, to Carpet King: You must be that gentleman I've read about. Aren't you a king or something?\""

"\"Batman: `Robin, England has no king now. England has a queen, and a great lady she is, too.\""

"\"Robin Gosh, Batman, this camel grass juice is great. Batman Beware of strong stimulants, Robin.\""


"\"Batman: `Robin, the Constitution provides that a man is innocent until proven guilty. And the Constitution is the cornerstone of our great nation. We must abide by it. Robin: `Gosh, when you put it that way...\""


"\"Batman: Man-eating lilacs have no teeth, Robin. It's a process of ingestion through their tentacles.\""

"\"Batman (after cracking a safe): `It's not difficult, if you have steady nerves and a good ear. Quality is destroyed by the tenor of criminal life.\""

"\"Batman: `An older head can't be put on younger shoulders."

"\"Robin: `Venus seemed like a nice girl in that costume. Batman: `I suspect she is a nice girl down deep, but she's fallen in with bad companions. And who knows what her home life was like.\""

"\"Batman:`Go back outside and calm the flower children. Robin: `They'll mob me Batman: `Groovy.\""


"\"Batman: `You know your neosauruses well, Robin. Peanut butter sandwiches it is.\""

"\"Batman: `Too many Bessarovian Cossacks around here, Robin. If I'd joined you in the fight, some of them may have been injured.\""

"\"Robin, about Batgirl, `She's gone again! For once, Batman, let's follow her.Batman: `No, Robin. With my head sticking out of this neosaurus costume, I might not appear like an ordinary, run of the mill crimefighter.\""


"\"Bruce: `Just because we're traveling, I don't think that Dick should neglect his studies, so we brought along one thousand key works of literature, his biological specimens, and also his own desk. Dick: `Yes, I expect to study hard.\""


"\"Batman: `You're far from mod, Robin. And many hippies are older than you are.\""

"\"Superintendent Watson: `Well, I think this calls for a cup of char at venerable Ireland Yard. Robin: `Char?' Batman:`Yes, Robin, a colloquialism for tea.\""

"\"Catwoman: Let noone say that Catwoman is not the best-dressed woman in the world.Batman: There are no fashion shows where you're going, Catwoman....Robin:`And how could a feline feloness like you also be a fashion model Batman:`Ah-ah. Give credit where credit is due, Robin. She may be evil, but she is attractive. You'll know more about that in a couple of years.\""

"\"Robin: If we close our eyes, we can't see anything. Batman: A sound observation, Robin.\""

"\"Robin, about Catwoman: Do you think she'll kill Batgirl? Batman: Or worse, Robin. Or worse.\""


"\"Batman: Nobody wants war. Robin: Gee, Batman. Belgravia's such a small country. We'd beat them in a few hours. Batman: Yes, and then we'd have to support them for years. Robin: `I'd rather shake hands with a spitting cobra! Batman: `You're being cynical, Robin. To err is human, to forgive...divine.\""

"\"Batman: `What took you so long, Batgirl? Batgirl: `Rush hour traffic, plus all the lights were against me. And you wouldn't want me to speed, would you? Robin: `Your good driving habits almost cost us our lives! Batman: `Rules are rules, Robin. But you do have a point.\""

"\"Batman: Cattail Lane and Nine Lives Alley. The Grimalkin Novelty Company is on that corner. Robin: Grimalkin? What kind of a name is that? Batman: An obscure but nevertheless acceptable synonym for cat, Robin.\""

"\"Robin, looking at Batgirl: `You know something, Batman? Batman: `What's that, Robin? Robin: `She looks very pretty when she's asleep. Batman: `I thought you might eventually notice that. That single statement indicates to me the first oncoming thrust of manhood, old chum.\""

"\"Robin: `Gosh, if I could just figure out that riddle. Why can't I get it? Batman: `Maybe your mind's on that cute little teenager who waved to you on the way across town, eh? Robin: `Awww, come on, Batman.\""

"\"Dick: `Awww, heck! What's the use of learning French anyway? Bruce: `Dick, I'm surprised at you! Language is the key to world peace. If we all spoke each other's tongues, perhaps the scourge of war would be ended forever. Dick: `Gosh, Bruce, yes. I'll get these darn verbs if they kill me!\""

"\"Robin: `What do we do, tip off Commissioner Gordon? Batman: `No, not on your life, old man. The Penguin and I have a score to settle.\""


"\"Dick: `Wow The rings of Saturn! This is sure some fun, Bruce. Bruce: `Astronomy is more than mere fun, Dick!. Dick: `It is? Bruce: `Yes, it helps give us a sense of proportion. Reminds us how little we are, really. People tend to forget that sometimes. Dick: Gosh yes, that's right. I'll bet I see those rings a little differently this time!\""

"\"Robin: `Gosh, there could be diplomatic repercussions if we fail this time, Batman. Batman: `That's not the point, Robin. What's important is that the world know that all visitors to these teeming shores are safe, be they peasant or king. Robin: `Gee, Batman, I never thought of that. You're right. Batman: `It's the very essence of our democracy.\""

"\"Batman to Robin: `Stop fiddling with that atomic pile and come down here!\""

"\"Dick: `Gosh, botany is tough. I'll never learn to recognize all these trees! Bruce: `Come come, Dick. Pine. Elm. Hickory, chestnut, maple. Part of our heritage is the lure of living things, the storybook of nature. Dick: `That's true, Bruce. I'll learn to read that book of nature yet!\""



"\"Batman: `Robin, you haven't fastened your safety bat-belt. Robin: `We're only going a couple of blocks. Batman: `It won't be long until you are old enough to get a driver's license, Robin, and you'll be able to drive the Batmobile and other vehicles. Remember, motorist safety. Robin: `Gosh, Batman, when you put it that way..\""

"\"Bruce: When we have more time, I'll acquaint you with the various processes of sculptoring. It's a fascinating art to which I devoted many hours of study. Dick: I sure would like to hear about it, Bruce.\""

"\"Batman (during a bat-climb): Careful, Robin. Both hands on the Bat-rope.  Robin: Sorry, Batman.\""

"\"Robin (about Lydia Limpet): Gosh, Batman, those look like honest eyes. Batman: Never trust the old chestnut, 'Crooks have beady little eyes'. It's false.\""

"\"Robin: When we put the fake jewels in Miss Starr's safe and take the real ones out, we could be nailed as crooks. Batman: That's a chance we have to take, Robin. In our well ordered society, protection of private property is essential. Robin: Yes, you're right, Batman. That's the keystone to all law and order.\""

"\"Dick Grayson: I thought Lima was the capital of Equador. Bruce Wayne: As you can see, I was right. It's the capital of Peru. Aunt Harriet: Oh, I just love this game of capitals. It's just so educational! Bruce: Not only that, if we don't know all about our friends to the south, how can we can carry out our good neighbor policy?\""

"\"Bruce: Most Americans don't realize what we owe to the ancient Incas. Very few appreciate they gave us the white potato and many varieties of Indian corn. Dick: Now whenever I eat mashed potatos, I for one will think of the Incas.\""

"\"Dick (working on a jigsaw puzzle): It's so much harder with the pieces upside down. Bruce: Of course. Think of what excellent training it is for your visual memory. Dick: Gosh yes, I guess that's true.\""

"\"Robin: Let's get going and make an emergency bat-turn!  Batman: Not this time, old chum. Have to think of the golfers. The retro-rockets would burn up the course for a hundred yards.\""

"\"Batman: Human mechanisms are made by human hands, Robin. None of them is infallible. It is a lesson that must be faced.\""

"\"Batman: That's life, Robin, full of ups and downs. It ill befits any of us to become to confident. Batman (about to cross the street): Remember Robin, always look both ways.\""


"\"Robin: It sure is a shame, Batman. A restaurant with such terrific chow turning out to be a mere front for some criminal scheme. Batman: Look at it this way, Robin. That $100 cover charge is pretty stiff. Penguin's 'terrific chow' is hardly within the budget of the average worker. Robin: Gosh yes, you're right, Batman. All the needy people in the world, all the hungry children. Batman: Good thinking, Robin.\""

"\"Dick: Gosh Bruce, Greek is still Greek to me. Aunt Harriet: It's Greek to a lot of Greeks too. It's one of the world's oldest, most important, most beautiful languages. Dick: It may be, Aunt Harriet, but can't we take a breather and work out in the gym for a while? Aunt Harriet: But the mind needs excercise too, Dick. Dick: Well, my mind is getting muscle-bound. Bruce: Ahhh, there is an old saying, Dick. A sound mind and a sound body. A worthy goal.\""

"\"Batman: Ma Parker's girl is more dangerous than her three boys. Robin: Her legs sort of reminded me of Catwoman's. Batman: You're growing up, Robin. Remember, in crime-fighting always keep your sights raised.\""



"\"Robin: But what is it? Batman: Saribus Sacer. A species of ancient Egyptian beetle, sacred to the Sun God, Hymeopolos. And from which the term scarab is derived. But, you should know that, Robin, if you are up on your studies of Egyptology. Robin: You're right.\""

"\"Batman: I know. Hieroglyphics self-taught are a chore, Robin; but, it is a surefire way to unravel the secrets of the ancient mystics.\""

"\"Batman: Experience teaches slowly, Robin. And at a cost of many mistakes.\""

"\"Robin: I am a little hungry. Batman: Of course, Robin. Even crime-fighters must eat. And especially you. You're a growing boy and you need your nutrition.\""

"\"Batman: Remember the Boy Scouts' motto. Robin: 'Be prepared'. Batman: It would do well to keep that in mind at all times.\""

"\"Robin: We better hurry, Batman.Robin: Right again, Batman.  Not too fast, Robin. In good bat-climbing as in good driving one must never sacrifice safety for speed.\""

"\"Batman: Tarnished reputations are unfortunate, Robin. We can live with those. However, a threat to all of Gotham City is something else.\""

"\"Robin: Self-control is sure tough sometimes, Batman! Batman: All virtues are, old chum. Indeed, that's why they're virtues.\""

"\"Robin: How about rushing the place, Batman?  Batman: Shh. I think not, Robin. All they've done so far is stolen a few items, attempted to kill you, me, and Batgirl. No, I think they plan something really big.\""

"\"Dick: Bruce, let me ride Waynebow. I'm light enough. Bruce: No, Dick, I couldn't allow my own ward to ride my own thoroughbred. People might think it was funny.\"" 

}

putlog "Batman Quotes 1.0 by FragUK loaded ..."
