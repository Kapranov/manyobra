/*
Name:           View - Services
Written by:     zettheme - (http://www.zettheme.com)
Version:        1.0
*/

(function() {

    "use strict";

    var Services = {

        initialized: false,

        initialize: function() {

            if (this.initialized) return;
            this.initialized = true;

            this.events();

        },

        events: function() {

            // Services Carousel
            $(window).load(function () {
                Services.servicesCarousel();
            });

        },

        servicesCarousel: function() {
            
            if(!$(".owl-carousel").get(0)) {
                return false;
            }

            var servicesCarousel = $(".owl-carousel");

            // Nav
            servicesCarousel.prepend(
                $("<a />")
                    .addClass("carousel-nav prev")
                    .attr({
                        "href": "#",
                        "id": "mainCarouselPrev"
                    })
                    .append(
                        $("<i />")
                            .addClass("fa fa-chevron-left")
                    )
            );

            servicesCarousel.prepend(
                $("<a />")
                    .addClass("carousel-nav next")
                    .attr({
                        "href": "#",
                        "id": "mainCarouselNext"
                    })
                    .append(
                        $("<i />")
                            .addClass("fa fa-chevron-right")
                    )
            );

            // Custom Navigation Events
            $("#mainCarouselNext").click(function(e) {
                e.preventDefault();
                slider.trigger("owl.next");
            });

            $("#mainCarouselPrev").click(function(e) {
                e.preventDefault();
                slider.trigger("owl.prev");
            });

            servicesCarousel.find(".flex-next").on("click", function() {
                servicesCarousel.OwlCarousel("prev");
            });

            servicesCarousel.find(".flex-prev").on("click", function() {
                servicesCarousel.OwlCarousel("next");
            });

        }

    };

    //Services.initialize();

})();