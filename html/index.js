const resource = GetParentResourceName();
var audioPlayer = null;

$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.type) {
            case "playsound":
                if (audioPlayer != null) {
                    audioPlayer.pause();
                }
    
                audioPlayer = new Howl({src: ["./sounds/" + event.data.transactionFile + ".ogg"]});
                audioPlayer.volume(100);
                audioPlayer.play();
            break;
        }
    });
});