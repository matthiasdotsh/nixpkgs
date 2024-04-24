import soundcard as sc

# get a list of all speakers:
speakers = sc.all_speakers()
# get the current default speaker on your system:
default_speaker = sc.default_speaker()
# get a list of all microphones:
mics = sc.all_microphones()
# get the current default microphone on your system:
default_mic = sc.default_microphone()


# alternatively, get a `Recorder` and `Player` object
# and play or record continuously:
with default_mic.recorder(samplerate=48000) as mic, \
      default_speaker.player(samplerate=48000) as sp:
    for _ in range(100):
        data = mic.record(numframes=1024)
        sp.play(data)
