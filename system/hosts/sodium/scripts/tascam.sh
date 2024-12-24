# get goxlr state, in plain text & json formats
goxlr_status=$(goxlr-client --status) # plain text is used for extracting volume in 0-100 format
goxlr_status_json=$(goxlr-client --status-json)

# get mixer key by grabbing the first mixer (unlikely to have multiple connected)
first_mixer_key=$(echo "$goxlr_status_json" | jq -r ".mixers | keys | .[0]")
# state of fader used for media / tascam porta 05, in this case "B"
fader_channel=$(echo "$goxlr_status_json" | jq -r ".mixers.$first_mixer_key.fader_status.B.channel")
fader_mute_state=$(echo "$goxlr_status_json" | jq -r ".mixers.$first_mixer_key.fader_status.B.mute_state")

# normalize json mute state to command format
case "$fader_mute_state" in
  "Unmuted") fader_mute_state="unmuted" ;;
  "MutedToX") fader_mute_state="muted-to-x" ;;
  "MutedToAll") fader_mute_state="muted-to-all" ;;
  *) ;;
esac

PORTA_COLOR="2778FF"
PORTA_TEXT="Porta 05"
MEDIA_COLOR="FF0321"
MEDIA_TEXT="Media"

set_lighting() {
  local fader_color="$1"
  local scribble_text="$2"
  
  goxlr-client faders scribbles text b "$scribble_text"
  goxlr-client lighting simple-colour scribble2 "$fader_color"
  goxlr-client lighting fader colour b 000000 "$fader_color"
  goxlr-client lighting button colour fader2-mute "$fader_color" 000000
}

get_volume() {
  # mixer input to fetch volume from e.g. Music, LineIn
  local mixer_input="$1"
  # strip volume from plain text status
  echo "$goxlr_status" | grep "$mixer_input volume" | awk -F': ' '{print $2}' | sed 's/%//'
}

if [ "$fader_channel" == "Music" ]; then # if fader B is currently controlling music (we want to swich to line in)
  set_lighting "$PORTA_COLOR" "$PORTA_TEXT"

  music_volume=$(get_volume "Music") # store current volume, to use for line in later

  # disable any undesired output from music
  goxlr-client router music headphones false
  goxlr-client router music broadcast-mix false
  goxlr-client router music chat-mic false
  goxlr-client router music sampler false

  # set line in to current music volume before switching the fader so there is no jump
  goxlr-client volume line-in "$music_volume"
  goxlr-client faders channel b line-in
  goxlr-client faders mute-state b "$fader_mute_state"
  goxlr-client volume music 100

  # enable required routes
  goxlr-client router music line-out true
  goxlr-client router line-in headphones true
  goxlr-client router line-in broadcast-mix true
  goxlr-client router line-in chat-mic true
  goxlr-client router line-in sampler true
else  # if fader B is not currently controlling music (we want to switch to music)
  set_lighting "$MEDIA_COLOR" "$MEDIA_TEXT"

  line_in_volume=$(get_volume "LineIn") # store current volume, to use for music later

  # disable any undesired output from line in
  goxlr-client router music line-out false
  goxlr-client router line-in headphones false
  goxlr-client router line-in broadcast-mix false
  goxlr-client router line-in chat-mic false
  goxlr-client router line-in sampler false

  # set line in to current line in volume before switching the fader so there is no jump
  goxlr-client volume music "$line_in_volume"
  goxlr-client faders channel b music
  goxlr-client faders mute-state b "$fader_mute_state"
  goxlr-client volume line-in 50

  # enable required routes
  goxlr-client router music headphones true
  goxlr-client router music broadcast-mix true
  goxlr-client router music chat-mic true
  goxlr-client router music sampler true
fi