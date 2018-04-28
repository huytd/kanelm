require('./index.html');
require('./main.scss');

const config = require('./config');
const Elm = require('./Main.elm');

fetch(config.URL, {
    headers: {
        "secret-key": config.SECRET
    }
})
.then(res => res.json())
.then(json => {
    var app = Elm.Main.fullscreen(json);

    app.ports.setStorage.subscribe(function(state) {
        fetch(config.URL, {
            method: "PUT",
            headers: {
                "content-type": "application/json",
                "secret-key": config.SECRET
            },
            data: JSON.stringify(state)
        });
    });
});
