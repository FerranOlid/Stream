#!/bin/bash

WKP=1023
port=6666

# Describes the script usage with its options
function usage () {
	echo "Usage: $0 [options] ... [Video] [Interface] [Channel_name]"
	echo "  options: "
	echo "  -p port: port to stream the video. Default: 6666"
	echo "  -h help"
	exit $1
}

# Getting options (for the time being, just help and port)
while getopts "p:" opt; do
	case $opt in
		p )	port=$OPTARG
			if [ "$OPTARG" -le "$WKP" ]
			then
				echo "WARNING: Port has been set to a well-known port ($port)"
				read -p "If you know what you are doing press [ENTER], otherwise press Ctrl+C"
			fi
			;;
		h ) usage 0 ;;
		\?) usage 1 ;;
	esac
done

# Skipping options to get to mandatory parameters
shift `expr $OPTIND - 1`

# Checking mandatory parameters
case $# in
	[0-2]) usage 1 ;;
	3)
		video=$1
		channel=$3
		ip=`ifconfig $2|grep "inet addr:"|sed 's/:/ /g'|awk '{print $3;}'`
		;;
esac

# Getting video info to create channel file...

# tmp is used to store audio info and is processed afterwards to get a few audio parameters
tmp=`ffprobe $video 2>&1 | grep "Audio" | cut -d':' -f3-`
audiocodec=`echo $tmp|cut -d',' -f1`
if [ -z $audiocodec ]
then
	audiocodec='mp2'
fi

audiochannels=`echo $tmp|cut -d',' -f3`
if [ "$audiochannels" == " stereo" ]
then
	audiochannels=2
else
	audiochannels=1
fi

# Setting sample rate (still to check if constant). default is 48 K
samplerate=48000

# Getting video format with ffprobe
vformat=`ffprobe $video 2>&1 | grep 'Video:' | cut -d':' -f3- | cut -d',' -f1 | cut -d' ' -f2`

# Getting width and height on a string so we can manage it afterwards
tmp=`mediainfo --Inform="Video;%Width% %Height%" $video`
# Getting width from tmp
width=`echo $tmp | awk '{print $1}'`
# Getting height from tmp
height=`echo $tmp | awk '{print $2}'`

# Calculating aspect ratio from width and height
# Using awk in order to get a floating point number
ratio=$(awk "BEGIN{print $width/$height}")

#Getting bit rate
bitrate=`mediainfo --Inform="Video;%BitRate%" $video`

#Printing info into channel file 
cat << EOF > ./channel
Channel $channel
{
	LaunchString = "-i $ip -p $port"
	AudioCodec = mp2
	AudioChannels = 2
	SampleRate = 48000
	VideoCodec = h264
	Width = $width
	Height = $height
	Ratio = $ratio
	Bitrate = 1000000
}
EOF

# Tmp instructions, just to test & develop
mv -f ./channel ps/channels.conf
cd ps
./source.sh -f $video -V libx264 -A mp2 -s "-I  $2"
