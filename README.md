Stream: automatization script for the PeerStreamer
======


To run this script, you need to install the PeerStreamer before. You can download it following the instructions in the following link: http://peerstreamer.org/content/download

To run the script, you need to provide the video filename, the interface where the video is streamed through, and the channel's name. The script will generate the channels.conf file which can be given to your friends or whoever you want so they can watch your streaming. Just run:

	./stream.sh vide_filename interface channel_name
	
You can also set the port with the -p option.


To stream a video, you need acces to the source.sh file from the PeerStreamer source. There are two ways to do it

   - Download the source code and compile it. It is available at www.peerstreamer.org/content/development

   - Copy the files in /opt/peerstreamer to a directory with read/write permissions to your user. To give the write permissons to all users on all files in a directory (e.g where you copied the content in /opt/peerstreamer) just run the following command (where PSdirecotry is the directory where you copied PS):

	~/PSdirectory$ sudo chmod -R a+w *

Once you got the source.sh file, you just need to copy that directory to the directory where the stream.sh script is contained.
