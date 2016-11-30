#!/usr/bin/env bash

declare canopen
declare logger

playlist=$1
workspace=~/Desktop/automator-youtube-dl
output_dir="playlist-$(date +%s)"
youtube_dl_url=https://yt-dl.org/downloads/latest/youtube-dl
ffmpeg_url=http://www.ffmpegmac.net/resources/SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_28.11.2016.zip

mkdir -p $workspace && cd $workspace

[[ $(uname) == "Darwin" ]] && {
    # audible logging for os x
    logger=say
    canopen=1

    # ensure ffmpeg is present
    [[ -f ffmpeg && -f ffserver && -f ffprobe ]] || {
        
        # start from scratch
        rm ff{mpeg,probe,server,mpeg.zip} || true
        curl --silent -L $ffmpeg_url -o ffmpeg.zip || {
            $logger "unable to download f f m peg archive, exiting!"
            exit 1
        }
        tar -xf ffmpeg.zip
        rm ffmpeg.zip
    }    
    # ensure youtube-dl is present
    [[ -f youtube-dl ]] || {
        curl --silent -L $youtube_dl_url -o youtube-dl || {
            $logger "unable to download you tube d l, exiting!"
            exit 1
        }
        chmod a+rx youtube-dl || {
            $logger "unable to make you tube d l executable, exiting!"
            exit 1
        }
    }
} || {
    logger=echo # stdout otherwise
    canopen=0

    # search for globals instead
    type ffmpeg && type ffserver && type ffprobe && type youtube_dl || {
        $logger "missing any of the following:" ff{mpeg,server,probe} youtube-dl
    }
} 

mkdir -p $output_dir && cd $output_dir

PATH=$PATH:$PWD/..

# attempt to download and transcode the given url
$logger "beginning you tube play list download, please wait..."
youtube-dl --prefer-ffmpeg --quiet \
           --no-warnings --no-progress \
           --ignore-errors --no-color \
           --yes-playlist --no-call-home \
           --extract-audio --audio-format="mp3" \
           --output="%(title)s.%(ext)s" \
           -- $playlist || {
    $logger "you tube play list download failed"
    exit 1
}

$logger "you tube play list download complete!"

if [[ $canopen == "1" ]]; then
    open $output_dir
else
    $logger "navigate to" $workspace/$output_dir
fi

exit 0