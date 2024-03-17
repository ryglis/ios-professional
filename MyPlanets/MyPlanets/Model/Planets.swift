//
//  Planets.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 17/03/2024.
//

import Foundation

struct Planet {
    let name: String
    let shortDescription: String
    let longDescription: String
    let imageName: String
    let code: Int
    var efemerid: PlanetEfemerid?
    
    init (name: String, shortDescription: String, longDescription: String, imageName: String, code: Int) {
        self.name = name
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.imageName = imageName
        self.code = code
    }
    
    mutating func updateEfemerid(planetEfemerid: PlanetEfemerid) {
        self.efemerid = planetEfemerid
    }
}

struct Planets {
    static let all: [Planet] = [
    Planet(name: "Sun",
           shortDescription: "Sun is the warmth of our hearts",
           longDescription: "The Sun is the star at the centre of the Solar System. It is a nearly perfect ball of hot plasma, heated to incandescence by nuclear fusion reactions in its core, radiating the energy mainly as visible light, ultraviolet light, and infrared radiation. It is by far the most important source of energy for life on Earth. Its diameter is about 1.39 million kilometers (864,000 miles), or 109 times that of Earth. Its mass is about 330,000 times that of Earth, and it accounts for about 99.86% of the total mass of the Solar System. Roughly three quarters of the Sun's mass consists of hydrogen (~73%); the rest is mostly helium (~25%), with much smaller quantities of heavier elements, including oxygen, carbon, neon and iron.",
           imageName: "sun",
           code: 10),
    Planet(name: "Mercury",
           shortDescription: "Mercury is the smallest and innermost planet in the Solar System.",
           longDescription: "Mercury is the smallest planet in the Solar System and the closest to the Sun. Its orbit around the Sun takes 87.97 Earth days, the shortest of all the Sun's planets. It is named after the Roman god Mercurius (Mercury), god of commerce, messenger of the gods, and mediator between gods and mortals, corresponding to the Greek god Hermes (Ἑρμῆς). Like Venus, Mercury orbits the Sun within Earth's orbit as an inferior planet, and its apparent distance from the Sun as viewed from Earth never exceeds 28°. This proximity to the Sun means the planet can only be seen near the western horizon after sunset or the eastern horizon before sunrise, usually in twilight. At this time, it may appear as a bright star-like object, but is more difficult to observe than Venus. From Earth, the planet telescopically displays the complete range of phases, similar to Venus and the Moon, which recurs over its synodic period of approximately 116 days.",
           imageName: "mercury",
           code: 199),
    Planet(name: "Venus",
           shortDescription: "Venus is the second planet from the Sun. It is named after the Roman goddess of love and beauty.",
           longDescription: "Venus is the second planet from the Sun. It is named after the Roman goddess of love and beauty. As the brightest natural object in Earth's night sky after the Moon, Venus can cast shadows and can be visible to the naked eye in broad daylight. Venus lies within Earth's orbit, and so never appears to venture far from the Sun, either setting in the west just after dusk or rising in the east a little while before dawn. Venus orbits the Sun every 224.7 Earth days. It has a synodic day length of 117 Earth days and a sidereal rotation period of 243 Earth days. As a consequence, it takes longer to rotate about its axis than any other planet in the Solar System, and does so in the opposite direction to all but Uranus. This means the Sun rises in the west and sets in the east. Venus does not have any moons, a distinction it shares only with Mercury among the planets in the Solar System. \nVenus is a terrestrial planet and is sometimes called Earth's \"sister planet\" because of their similar size, mass, proximity to the Sun, and bulk composition. It is radically different from Earth in other respects. It has the densest atmosphere of the four terrestrial planets, consisting of more than 96% carbon dioxide. The atmospheric pressure at the planet's surface is about 92 times the sea level pressure of Earth, or roughly the pressure at 900 m (3,000 ft) underwater on Earth. Even though Mercury is closer to the Sun, Venus has the hottest surface of any planet in the Solar System, with a mean temperature of 737 K (464 °C; 867 °F). ", 
           imageName: "venus",
           code: 299),
    Planet(name: "Earth",
           shortDescription: "Earth is the third planet from the Sun and the only astronomical object known to harbor life. It is home to millions of species, including humans.",
           longDescription: "Earth is the third planet from the Sun and the only astronomical object known to harbor life. While large amounts of water can be found throughout the Solar System, only Earth sustains liquid surface water. About 71% of Earth's surface is made up of the ocean, dwarfing Earth's polar ice, lakes and rivers.",
           imageName: "earth",
           code: 399),
    Planet(name: "Mars",
           shortDescription: "Mars is the second-smallest planet in the Solar System. It is named after the Roman god of war.",
           longDescription: "Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, being larger than only Mercury. In English, Mars carries the name of the Roman god of war and is often referred to as the \"Red Planet\". The latter refers to the effect of the iron oxide prevalent on Mars's surface, which gives it a reddish appearance, that is distinctive among the astronomical bodies visible to the naked eye. Mars is a terrestrial planet with a thin atmosphere, with surface features reminiscent of the impact craters of the Moon, and the valleys, deserts and polar ice caps of Earth.",
           imageName: "mars",
           code: 499),
    Planet(name: "Jupiter",
           shortDescription: "Jupiter is the largest in the Solar System. It is a gas giant with prominent rings and many moons.",
           longDescription: "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined, but slightly less than one-thousandth the mass of the Sun. Jupiter is the third brightest natural object in the Earth's night sky after the Moon and Venus. People have been observing it since prehistoric times; it was named after the Roman god Jupiter, the king of the gods, because of its observed size.", 
           imageName: "jupiter",
           code: 599),
    Planet(name: "Saturn",
           shortDescription: "Saturn is the second-largest in the Solar System, after Jupiter. It is known for its distinctive rings.",
           longDescription: "Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius of about nine and a half times that of Earth. It only has one-eighth the average density of Earth; however, with its larger volume, Saturn is over 95 times more massive",
           imageName: "saturn",
           code: 699),
    Planet(name: "Uranus",
           shortDescription: "Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System.",
           longDescription: "Uranus is the seventh planet from the Sun. Its name is a reference to the Greek god of the sky, Uranus, who, according to Greek mythology, was the great-grandfather of Ares (Mars), grandfather of Zeus (Jupiter) and father of Cronus (Saturn). It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have bulk chemical compositions which differ from that of the larger gas giants Jupiter and Saturn. For this reason, scientists often classify Uranus and Neptune as \"ice giants\" to distinguish them from the other giant planets.", 
           imageName: "uranus",
           code: 799),
    Planet(name: "Neptune",
           shortDescription: "Neptune is the farthest known planet from the Sun in the Solar System. It is named after the Roman god of the sea.",
           longDescription: "Neptune is the eighth and farthest-known Solar planet from the Sun. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. It is 17 times the mass of Earth, slightly more massive than its near-twin Uranus. Neptune is denser and physically smaller than Uranus because its greater mass causes more gravitational compression of its atmosphere. It is referred to as as one of the solar system's two ice giant planets (the other one being its near-twin Uranus.)",
           imageName: "neptun",
           code: 899),
    ]
}
//
//Planet(name: "Pluto",
//       shortDescription: "Dwarf planet",
//       longDescription: "Pluto is a dwarf planet in the Kuiper belt, a ring of bodies beyond the orbit of Neptune. It was the ninth planet to be discovered.",

