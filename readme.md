
# automator-youtube-dl

to make modifications to this application, open it with automator and hack away! the shell script powering the app is as follows:

```bash
playlist=$1
output_dir="playlist-$(date +%s)"
ffmpeg_url=http://www.ffmpegmac.net/resources/SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_28.11.2016.zip

cd ~/Desktop
mkdir -p youtube
cd youtube

PATH=$PATH:$PWD

[[ ! -f ffmpeg ]] && {
	rm ffmpeg ffprobe ffserver || true
	curl --silent -L $ffmpeg_url -o ffmpeg.zip || {
		say "unable to download f f m peg archive, exiting!"
		exit 1
	}
	tar -xf ffmpeg.zip && rm ffmpeg.zip || {
		say "unable to extract f f m peg archive, exiting!"
		exit 1
	}
}

[[ ! -f youtube-dl ]] && {
	curl --silent -L https://yt-dl.org/downloads/latest/youtube-dl -o youtube-dl || {
		say "unable to download you tube d l, exiting!"
		exit 1
	}
	chmod a+rx youtube-dl || {
		say "unable to make you tube d l executable, exiting!"
		exit 1
	}
}

mkdir $output_dir || {
	say "unable to create output directory, exiting!"
	exit 1
}

cd $output_dir || {
	say "unable to change to output directory, exiting!"
	exit 1
}

say "beginning you tube play list download, please wait..."

youtube-dl \
	--prefer-ffmpeg \
	--quiet \
	--no-warnings \
	--no-progress \
	--ignore-errors \
	--no-color \
	--yes-playlist \
	--no-call-home \
	--extract-audio \
	--audio-format=mp3 \
	--output="%(title)s.%(ext)s" \
	-- $playlist || {
        say "you tube play list download failed!"
        exit 1
    }

say "you tube play list download complete!"
open $output_dir
exit 0
```
