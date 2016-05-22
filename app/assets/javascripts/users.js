// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

'use strict';

var presentLocation = {
    lat: 20.5937,
    lng: 78.9629
};
var map;
var markers = [];


function EventEmitter() {
    this.__events = {};
}

EventEmitter.prototype = {
    on: function(ev, cb) {
        this.__events[ev] = this.__events[ev] || [];
        this.__events[ev].push(cb);
    },
    remove: function(ev, cb) {
        if(!(ev in this.__events)) return;
        this.__events[ev].splice(this.__events[ev].indexOf(cb), 1);
    },
    emit: function(ev) {
        let args = ([]).slice.call(arguments, 1);
        if(ev in this.__events) this.__events[ev].map(function(cb) { cb(args) });
    }
};

var events = new EventEmitter();
var defaultZoom = 13;

var G = window.G = (function() {
    return {
        loadUserLocation: function () {
            getGeoCoords().then(cords => {
                let src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDokEf6ZI2owU1_U1bsfFxsSmEAELs3TRM&libraries=places&callback=G.initMap";

                presentLocation = Object.create(cords);
                $("body").append(`<script src=${src} async defer></script>`);
            }).catch((e) => {
                console.log(e)//handle error;
            });
        },

        initMap: function () {
            let mapEl = document.querySelector("#map");
            let input = document.querySelector('#location_address');

            if(!mapEl) return;

            map = new google.maps.Map(mapEl, {
                center: { lat: presentLocation.lat, lng: presentLocation.lng },
                zoom: 13
            });
            let marker = new google.maps.Marker({
                map: map,
                anchorPoint: new google.maps.Point(0, -29)
            });

            events.emit("map::loaded");

            if(input) {
                let autocomplete = new google.maps.places.Autocomplete(input);

                autocomplete.bindTo('bounds', map);
                autocomplete.addListener('place_changed', function(e) {
                    handleChange(e, marker, autocomplete, map)
                });
            }
        },

        showMarkersOnMap: function (options) {
            options = options || {};

            events.on("map::loaded", function() {
                markers = ([]).map.call($(".location"), function(l) {
                    return new google.maps.Marker({
                        position: new google.maps.LatLng(l.dataset.lat, l.dataset.lng),
                        map: map,
                        title: l.dataset.address
                    });
                });

                if(markers.length) {
                    let bounds = new google.maps.LatLngBounds();
                    for (let i = 0; i < markers.length; i++) {
                        bounds.extend(markers[i].getPosition());
                    }

                    google.maps.event.addListenerOnce(map, 'bounds_changed', function(event) {
                        this.setZoom(map.getZoom()-1);

                        if (this.getZoom() > 15) {
                            this.setZoom(15);
                        }
                    });

                    let mapOptions = {
                        scrollwheel: 'disableZoomOnScroll' in options ? options.disableZoomOnScroll : true,
                        zoom: options.zoom ? options.zoom : defaultZoom,
                        minZoom: 1
                    }

                    map.setOptions(mapOptions);

                    map.fitBounds(bounds);

                    markers.map(function(m) {
                        m.setMap(map);
                    });
                }
            });
        },
    }
})();

$(document).on('input', '#search_users', function() {
    $.ajax({ url: '/search_users', data: { username: this.value }, dataType: 'script' });
});

function getGeoCoords() {
    if(!navigator.geolocation) {
        throw new Error("UNSUPPORTED");
    } else {
        return new Promise((resolve, reject) => {
            navigator.geolocation.getCurrentPosition(function(position) {
                resolve({ lat: position.coords.latitude, lng: position.coords.longitude });
            }, function() {
                reject(new Error("UNSUPPORTED"));
            });
        });
    }
}


function handleChange(e, marker, autocomplete, map) {
    marker.setVisible(false);

    let place = autocomplete.getPlace();

    if (!place.geometry) {
        window.alert("Autocomplete's returned place contains no geometry");
        return;
    }

    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
        map.fitBounds(place.geometry.viewport);
    } else {
        map.setCenter(place.geometry.location);
        map.setZoom(17);
    }

    marker.setIcon(({
        url: place.icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(35, 35)
    }));

    marker.setPosition(place.geometry.location);
    marker.setVisible(true);

    fillInAddress(place);
}

function fillInAddress(place) {
    let lat = $('#location_lat');
    let lng = $('#location_lng');
    let componentForm = {
        street: 'short_name',
        city: 'long_name',
        country: 'long_name',
        postal_code: 'short_name'
    };

    if (place.address_components) {
        for (var i = 0; i < place.address_components.length; i++) {
            let addressType = place.address_components[i].types[0];
            if (componentForm[addressType]) {
                let val = place.address_components[i][componentForm[addressType]];

                if($(`#location_${addressType}`)) {
                    $(`#location_${addressType}`).val(val)
                }
            }
        }
    }

    if(place.geometry) {
        $(lat).val(place.geometry.location.lat());
        $(lng).val(place.geometry.location.lng());
    }
}
