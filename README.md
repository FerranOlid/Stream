Stream: automatization script for the PeerStreamer
======


First of all, you need to download PeerStreamer to make this script works. You can download PS(PeerStreamer) following the instructions in: http://peerstreamer.org/content/download

To run the script, you need to provide the video filename, the interface where the video is streamed through, and the channel's name. The script will generate the channels.conf file which can be given to your friends or whoever you want so they can watch your streaming. Just run:

	./stream.sh vide_filename interface channel_name
	
(You can also set the port with the -p option)


The stream.sh needs acces to the source.sh file from the PeerStreamer source, so you need to provide it to him. To do it, you got these two ways:

   - Download the source code and compile it. It is available at www.peerstreamer.org/content/development

   - Copy the files in /opt/peerstreamer to Stream/ps/. You will probably need to give write permissions to your users. To give the write permissons to all users over all files in a directory (in this case in Stream/ps/) just run the following command:

		sudo chmod -R a+w *

Once you got the source.sh file, get fun streaming your videos!
