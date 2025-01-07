# Sulci - A Jabber/XMPP Bot

This is a fork of the original [Sulci bot by Ermine](https://github.com/ermine/sulci)
to maintain it in a more or less buildable and runnable condition inside Docker
containers. Some of its original functionality that was dependent on external 
resources has ceased to work, but it is still usable as a foul language moderator and
fun conversationalist.

## Usage

- Create directories for storing config files, databases, and logs, then mount
  them to the container according to the `docker-compose.yml` example.
- Copy `sulci-docker.conf.example` to the configs folder created above as
  `sulci.conf` and edit it to your needs.
- Run the container once to initialize databases.
- Edit `sulci_muc.db` manually to set up MUC auto-join with any sqlite3 capable
  database editing tool like [DB Browser for SQLite](https://sqlitebrowser.org/).

## Build

Refer to `Dockerfile` for building procedures in case of a wish of running 
the bot outside of docker container.

## Included plugins and their commands

### Admin
Provides basic admin commands.

- **`.msg <jid> <message>`**  
  Sends a message to a specified JID. Botmaster only.  
  Example: `.msg user@example.com Hoi!`

- **`.quit`**  
  Shuts down the bot gracefully. Botmaster only.

- **`.lang_update <lang>`**  
  Updates the bot's language setting. Botmaster only.

- **`.lang_msgid <language> <msgid> <string>`**  
  Updates a localized message string for a specific message ID. Botmaster only.  
  Example: `.lang_msgid ru plugin_cerberus_cannot_kick_admin не болтай глупостей как малолетка!`

- **`.sh <cmd>`**  
  Executes a shell command on the bot's host machine. Botmaster only. **Dangerous.** Disabled by default.  
  Example: `.sh ls -la /`

### Admin MUC
Managing Multi-User Chat (MUC) rooms.

- **`.msg <jid> <message>`**  
  Sends a message to a specific JID or room. Botmaster only.  
  Example: `.msg room@conference.example.com Hello!`

- **`.join <room> [nick]`**  
  Joins a MUC room with an optional nickname. Botmaster only.  
  Example: `.join room@conference.example.com mynick`

- **`.leave <room> [reason]`**  
  Leaves a MUC room with an optional reason. Botmaster only.  
  Example: `.leave room@conference.example.com Goodbye!`

- **`.invite <who> [room]`**  
  Invites a user to a room. If no room is specified, the current room is used. Botmaster only.  
  Example: `.invite user@example.com room@conference.example.com`

- **`.nick <new_nick>`**  
  Changes the bot's nickname in the current room. Botmaster only.  
  Example: `.nick newnick`

### Brainfuck
Brainfuck interpreter.

- **`.bf <brainfuck_code>`**  
  Runs Brainfuck interpreter. ([ and ] do not work).  
  Example: `.bf +++>++.`

### Calc
Calculator.

- **`.calc <expression>`**  
  A general-purpose calculator that evaluates mathematical expressions.  
  Example: `.calc 2 + 3 * (4 - 1)`

- **`.rpn <RPN_expression>`**  
  A calculator that evaluates mathematical expressions written in 
  Reverse Polish Notation (RPN) format.  
  Example: `.rpn 2 3 4 1 - * +`

### Currency
Currency converter.

- **`.curr list`** 
  Displays the current list of currency exchange rates fetched from 
  the Central Bank of Russia (CBR). Rates are updated daily.

- **`.curr refresh`** 
  Forces a refresh of currency exchange rates by fetching 
  the latest data from the Central Bank of Russia (CBR).

- **`.curr <amount> <from_currency> <to_currency>`** 
  Converts an amount from one currency to another using the latest exchange rates.  
  Example: `.curr 100 USD EUR`

### Dict (not functioning)
Queries dictionary definitions from a DICT protocol server.

- **`.dict <word>`**  
  Looks up the definition of a single word in the default dictionary database.  
  Example: `.dict hello`

- **`.dict <database> <word>`**  
  Looks up the definition of a word in a specific dictionary database.  
  Example: `.dict wn hello`

- **`.dict -list`**  
  Lists all available dictionary databases on the server.

- **`.dict * <word>`**  
  Looks up the definition of a word across all available databases.  
  Example: `.dict * hello`

### Google (not functioning)
Integrates Google services.

- **`.google <search query>`**  
  Performs a Google search and returns the first result.  
  Example: `.google "OCaml programming language"`

- **`.translate <source_language> <target_language> <text>`**  
  Translates text using Google Translate.  
  Example: `.translate en fr "Hello, how are you?"`

### Hostip (not functioning)
Intergrates HostIP.info API.

- **`.hostip <ip_or_hostname>`**  
  Retrieves the geographic location of the provided IP address or hostname.  
  Example: `.hostip 8.8.8.8`

### Misc
Miscellaneous utility commands.

- **`.dns <domain/ip>`**  
  Resolves a domain name to its IP address or performs a reverse DNS lookup for an IP address.  
  Examples:  
  `.dns example.com`  
  `.dns 8.8.8.8`


### Mueller (not functioning)
Searching and translating words using the Mueller dictionary.

- **`.mueller <word>`**  
  Searches for a word in the Mueller dictionary and returns its definition.  
  Example: `.mueller hello`


### Ping
Measures the round-trip time.

- **`.ping <entity>`**  
  Measures the round-trip time to the specified XMPP entity.  
  Example: `.ping user@example.com`


# TLD
Provides information about top-level domains (TLDs) by querying a database.

- **`.tld <domain>`**  
  Returns information about the specified top-level domain.  
  Example: `.tld com`

- **`.tld *`**  
  Provides a link to the IANA website listing all country code TLDs.  
  Example: `.tld *`

### Translate (not functioning)
Uses the m.translate.ru service to translate text between various language pairs.

- **`.tr list`**  
  Lists all available language pairs for translation.  
  Example: `.tr list`

- **`.tr [lang] [text]`**  
  Translates text between specified language pair (not functioning).  
  Example: `.tr er Hello` (translates "Hello" from English to Russian)

### Userinfo
Queries user and server details like version, time, idle status, uptime, and statistics.

- **`.version`**  
  Get client or server version details.  

- **`.time`**  
  Get current time for user or server.  

- **`.idle`**  
  Check user's idle time.  

- **`.uptime`**  
  Get server or user uptime.  

- **`.stats`**  
  View server statistics (e.g., online/total users).  

### vCard
vCard information.

- **`.vcard [jid]`**  
  Retrieves and displays vCard information for a specified XMPP entity.  
  Example: `.vcard user@example.com`


### Vocabulary and Vocabulary MUC
Manages vocabulary database.

- **`.dfn <key=[value]>`**  
  Defines or updates a term. If the term exists, it will be replaced. If the value is empty, the term is removed.  
  Example: `.dfn ocaml=awesome`

- **`.wtf <key>`**  
  Retrieves the definition of a specific term.  
  Example: `.wtf ocaml`

- **`.wtfall <key>`**  
  Retrieves all definitions for a specific term.  
  Example: `.wtfall ocaml`

- **`.wtfrand`**  
  Retrieves a random term and its definition.

- **`.wtfcount [key]`**  
  Counts the number of definitions for a term. If no key is provided, it returns the total number of terms.  
  Example: `.wtfcount ocaml`

- **`.wtffind <text>`**  
  Searches for terms or definitions containing the specified text.  
  Example: `.wtffind awesome`

- **`.wtfremove <key[=value]>`**  
  Removes a specific definition for a term. If no value is provided, all definitions for the key are removed. Moderators only.  
  Example: `.wtfremove ocaml=awesome`

### Weather (not functioning)
Displays weather.

- **`.wz <code>`**  
  Fetches weather data for a given 4-letter airport code.  
  Example: `.wz ULLI` (fetches weather for Pulkovo Airport, St. Petersburg)

### Yandex (not functioning)
Integrations with Yandex services.

Commands:
- **`.blogs <query>`**  
  Searches for blog posts on Yandex Blogs.  
  Example: `.blogs OCaml programming`

### Markov SQLite3
Generates Markov chains from chat messages, storing word pairs in an SQLite database. It can generate random text based on learned patterns and provide statistics about the stored data.

- **`.!!!count`**  
  Returns the total number of word pairs stored in the Markov database.

- **`.!!!top`**  
  Displays the top word pairs with their occurrence counts.


### Roulette
Implements a Russian roulette-style game in MUC rooms, where participants can be randomly kicked from the room.

- **`.tryme`**  
  Initiates a roulette game. If the user is not a moderator, they have a 1 in 10 chance of being kicked from the room.

### Talkers
Tracks and analyzes user activity in chat rooms, storing statistics about words spoken, sentences, and actions.

- **`.talkers`**  
  Displays statistics about top talkers in the current room.

- **`.talkers <nick>`**  
  Displays statistics for a specific user in the current room.  
  Example: `.talkers username`

## Credits

The original [bot's code](https://github.com/ermine/sulci) 
is by Anastasia Gornostaeva.
