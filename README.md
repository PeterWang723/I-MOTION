<div align="center">
	<!<img src="Stuff/AppIcon-readme.png" width="200" height="200">
	<h1>I-MOTION</h1>
	<p>
		<b>Application for building your own behavior and city behavior!</b>
	</p>
	<br>
	<br>
	<br>
</div>

## Introduction
The I-MOTION Mobility, Social, Energy & Location Analytics application efficiently gathers raw sensor data from mobile devices, which is then sent to the IMOTION back-end system. 
Here, the data undergoes processing to construct partial journeys, which are composed of either solely tracks or tracks combined with stays. 
Tracks represent movements from one origin to a destination via a specific mode of transport, while stays represent periods of stationary activity, each with a distinct purpose.

This application serves a wide range of uses within the mobility sector. 
For instance, it provides detailed mobility data essential for transportation planning. 
By analyzing this data, planners can assess the usage of the transport network, evaluate the efficiency of existing infrastructure, manage passenger flows more effectively, and design innovative mobility services. 
Utilizing this application allows for the optimization of timetables and routes, expansion of transport services, and enhancement of passenger attraction efforts.

## Download
<img src="https://sindresorhus.com/assets/download-on-app-store-badge.svg" width="130" height="130">
<img src="assets/google_play.svg" width="130" height="130">



## Features

### Real-Time Motion Trail & Trip Timeline Prediction Demonstration

- I-MOTION can show users' trips and activites in the specific 
day.
- Users can choose to see any day of their trails by switching in the calendar.

### Background Sensors' Updating with No Sense

- When users don't use this application in the foreground, the application still record telephone's sensors(GPS, accelerometer, heart readers, etc.)

### Verification of Predictions

- Although this application will predict users' type of trips like modes of transport, users can still edit these predictions to make them as accurate as possible.

### Join Families & Friends

- Users can join their families in their activities and trips if families are connected by unique household ID.
- Users can also add others outside family by typing users' ID.

### Statistical Summary of Analysis

- Applications summarises variable aspects of users' trips weekly, monthly, yearly, such as:
 	- percentage of modes of transports
	- data usage
	- electrical & fuel usage at home or in cars

### Third-Party API Support

- Application integrates with APIs from partners, like Octpus Energy for electrical usage, SmartCar for fuel usage.

### Community Ranking for Good

- Show users' ranking of green trips with their near people or the whole nations.

## Frontend Design
<a href="https://www.figma.com/file/00Vu2B48kec9gSvAqu9Kug/IMOTION-Project?type=design&node-id=402%3A27624&mode=design&t=WScarhWs5W14s5Sn-1">I-MOTION Frontend Design </a>

## Backend Architecture

<a href="https://viewer.diagrams.net/index.html?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Project.drawio#R7L1Xn6vYlT78aXz5nx9RQpfknEESuiOJDJIAET79uzeqqlN16rTd4%2Blu2%2FOO22riTis%2Ba%2B1F9d9wtpnFR3jL9S5J679hSDL%2FDef%2BhmEouafAAd5Z3u4gKPa6kz2K5O3ejxtusabvL77dHYsk7b%2B8OHRdPRS3rzfjrm3TePhyL3w8uunra9eu%2FjrqLczSbzfcOKy%2F3z0VyZC%2F7uI4gvx4IKVFlr8NDR4dXk%2Ba8P3tt1f7PEy66dMtnP8bzj66bnidNTOb1pB874R5tRN%2B4%2BnHzB5pO%2FyeBu3OoqcxLWO2muu7fLgsfvf%2FyFcvz7Ae31bMdu0QFm36ALe5IsweYfM2%2F2F5p8qQzmBIJh%2BaGtxAwWlYF1kLzmMwGdAUZ57pYygAHem3B02RJLA5M%2BXFkLq3MIZ9TUBswL1HN7ZJCueJgKtrUddsV3ePbTD8SsVpHIP7%2FfDoqvTTk4giCRK2%2BE6KN%2BrAWaTzp1tvpBHTrkmHxwJeeXtKvHHpTVAx4l0Cpx9sx%2FC3e%2Fknjr%2FfC98kLfvo%2BgcvwMkbO%2F4brNl%2FY43fQ678xIu%2BSoc4fyNdNw414B37oQ0bPQFHP1EN%2FCPAaTCAtUmR%2FnjWdm36KzJ%2FNPiZMdv%2FwP0k7PMP7r0zXgujtLa6vhiKDgpA1A1D1%2FxCMobu9isB%2BiRccAFvpgGYj7frNwrAIcP%2B9lrttZjhPBigajf4sJkzaJf%2BK5x64r8ead%2BNjziVYzgfBly%2Bzr6%2BNfbb6H%2BARFFfJQpHD%2BR%2Fkd9kavcLkdr9WSJFfROpb%2BL0VRV%2FpayfGPPBePSPIdnPNMMOB%2BQXNCN35HeiEfs%2Fi2qHf0y1tE1o6G2gANdh3xcvexU%2Bhu%2B3P9HvK7EB3R7L%2BfNFAC8AAd4uufnzQ255u%2FpNwr%2Fk%2FR%2BbGDDPLB3%2BsdykyRdn%2BZ2Nn3n0C7l%2Bv%2FdI63Aonl9d7K%2FY9jaC1RVgZR9Sgv6sWRjxoVnvvbyW%2Ftbws1P8qa8P8%2F0LLX3v60Web31tsvSx%2BH9evN4dzWcfXEO7%2FBe73T9Ff3e%2F0t9f2bw%2FzY2i6Dfy%2FnsZPZQ4%2FCSDCPYrqlHoL8hG%2FHl0w77RzU0fz18gkH97sfxG4d%2FwK3%2BtXOL%2F5nKJ7cmvRNvvvkPiw6%2BEEiX%2FNKIR34gmm%2B7fMNAbQrfJowOtwdnt9ndIif5jUv4B1MOJn5X6lyKHYn8l%2FkO%2Fh3unEEQP7yQ8peEDnv97UhDc%2BNdTcPeNgnoXFYBGvybav71t%2FC6nv3TZ%2B7%2FUNH4PfTcx%2FV9DYxz9VSj419L4d0Q1f7XG736mE%2FZrjUd%2BQaiPjOEfTinsOz5307bv%2FgOB0HcC%2FxJpEr8Ir7E%2Fjby%2FA5%2F%2FCuX8MvHzRyWffk4gZU1S%2F1cGc87f02P77Z%2Fv6bGP%2Bx%2BJX%2BSj%2BXsuGWazviTw%2Fggm77H%2FIn9iM%2Fkre4P%2Fgs04%2BWex%2BXs4IVruf6AKkT%2FT9pe47le2HPvTaPs7Qol3iS6abcfjH2tKDR8wYVxlGw3fBTtJr%2BFYD7%2BtSj%2Br5DYg%2FX4Xeb8DuwqH8G84%2FbrEhP6Z%2FQ1jZsB4jLUkA7ssDBGd5jFekSKUHCTmuqeGJ3iykLi%2BkM%2B4iZ96SU86e1iTJi5k6VLHrXGLMOIgl%2Fyou3KWNHWdIMoz5ZBCZ%2BlJ5vhJL%2B1M9%2BjFYOUsFI%2B3C5YjliuvekFMusQQcsHg4clBQthmVaYUvBdgcx7j%2BkFu6hL0X1jlPAVnp5PFyy0Sp4Nc6Kju%2BbPh8YUs2ge5QnDDC0bTqxaZiwnDJTCjdHK91EeDkxGZk1ettMEctjlluovA8XGjzAZ91Ue9zBm9jDGtzDDwzmKsoC8uAO3o7LWObDIKAlz7KOgbN9YL6DubtTLIPo7be%2FQA5rFoJY2Y27WMg3aEAWnwo%2F%2FprV8CzGEGYwH6VOBZvBoFvegLgWw0%2B5g7eNelZ83TwRpkQubgEdKTXvUyGI3Sx8C9BYyDgbFhvzNcIzifNA%2FQmYXz1mG%2Fy4%2FjNj7oE44ro9u4Kz0ankykhfz8HfRegCwAesP5BBOgyWxyv0Xvbf5gLjZcP2KKGbLRhMv%2FDn%2Fg8e19qcsiz8egvBhcluki%2F5s02ujPQd7ZRPje%2Fu%2B%2Fn72%2Fn4I1mV4M1pRBegE%2BAd40W1sU0OXV1vM%2FaPfig0y88yX6sYa38d7osbWBz3xUL97pAeQP8MGEPITHbY06abLEBO%2BBOYw6B2Xyt9rTuF5WI%2BDb69hM39YYeB9tfqzhRd83mQe0fMn%2BThaR9%2FaAfjqQZx37O%2B2zn9rrxiqTmw6sGQ7aEIb423R7p9f7EdAdyDEP5kwDWYoXE%2Bjuf2PsXvP%2BGbojn%2BjOE0BHMJ3LwNr9GcpM8K1P%2B4devcmLzDHY%2B%2FnfeX%2F49D6kM2FAnecgn3zQhge0moYfchmANcVLAGgDdAoxuW2dKOibMD%2FsBoKC%2Ba467APYPH3TQX0C9mP5cXzZLQ3IkQltwlqB9wLwnjy92zjQx8suvfdbxmBsaPN4yH9SBzKllRVisAi49legC2A%2BNrA3kE82Ybxo9tEe2IZRLxBoHyewJjDnANhYBNoXHNB%2F1qFNBjTWPXvUt%2BPH3OEcgd1hBiAT6CY%2FgD9ADmYD8PedNhp431gzJAZtwBoGA%2FIPrM2AOsv5mObxgJ7ZAsaegR6RgMYDmCO0w%2FhLBuA6Asz4LXuw8euDjyvoH9U5p9xktuRhe0APfYLPwBHKEPJms8GcM8KEfPTkEYw3v3iXl2BOoA2gkeeDOcYLkFX0pSf827UO1mJ%2FyFQEePuiGw3o5i%2FAdgFbEIwvm7Ad3%2BUYA%2FQk4BqM7RcD2vCA7wFYazx%2FkncS2lrQdoC%2BAsqTsYJ3N1mIIV2wH30CnwJ4BOY86S%2B6LZDfOvAZgC6Q35O%2B%2FtBDY6NdBvRYBmsMUKPtCm0lKA0HWGIlIAz6g%2FD174rmiV9l6%2F%2B0IOp7XpSO47ROH3CA%2F8Sc%2FY74CWfjxK%2BofPgrcybY9%2FTpvz5n8vMG5q83j36ZJcWQP41Su2%2BEgZvH70Ub3WPIu6xrw5r%2FcfcnGfrxjtbByGIjWJkOw%2FJWChKOQ%2FeVnOlcDOdP55%2B2z8HVj91zePG%2Bef6x6f7%2FkP9CsK8b7xSK%2F4Ot9%2B3KSh%2FFS8v%2Bp%2Fvx7%2Fn5f7gh%2F569%2B4c78r97q%2F1%2Fxu7vCVsZWpErEPz%2BP9D2fNMp5PduF%2F55abLfUbvzqQrlrZbrN2tNfpNK%2FyY1Ht9ZQCH%2FbI3HnvzHff1GjQcgZ7h8eu0GX%2Bj%2FzrS%2FbeV%2FDPVPzO6HvLzm8YeWnWD%2FvbKm%2F3UCheJ%2FnED9oq8%2FSKD%2BzlB%2FqnTg3zc9vknH%2F6UU%2F%2BSU4qRzNPy9p7hgGnHVX%2F%2FAEI2EoZUBrxD9p2db2gCEo%2BBqoUmYwjA8EGaXMXimgzDr7c0FhMEgXH27WkEYDcPMtyvYMwivQHhseDRoG%2BDyFnrpMOwkDCHATZge8F5vBysIuV0Q5pbyaxwWpiVfYwLagHAQhO5bH%2Fy0hb3wB8cH75meDa6TfHsPpgfej%2B%2BhPAzhOR%2BOM4AwE4Sh02yAecEQVfMyBKYft3lgPOAjDC%2Ff1rqCUJ6riNe47yF1DENgdFvhFkrLp">I-MOTION Backend Design</a>

## Database Structure
<a href="https://dbdocs.io/w906323199/I-MOTION-database?view=relationships">I-MOTION Database Design </a>

## Test & Evaluation 
## Next Steps

## References

- Liang, Xiaoyuan, et al. "A deep learning model for transportation mode detection based on smartphone sensing data." IEEE Transactions on Intelligent Transportation Systems 21.12 (2019): 5223-5235.
- Xiao, Guangnian, Zhicai Juan, and Chunqin Zhang. "Detecting trip purposes from smartphone-based travel surveys with artificial neural networks and particle swarm optimization." Transportation Research Part C: Emerging Technologies 71 (2016): 447-463.
- Zhou, Yang, et al. "The smartphone-based person travel survey system: data collection, trip extraction, and travel mode detection." IEEE Transactions on Intelligent Transportation Systems 23.12 (2022): 23399-23407.
- Prelipcean, Adrian C., Győző Gidófalvi, and Yusak O. Susilo. "MEILI: A travel diary collection, annotation and automation system." Computers, Environment and Urban Systems 70 (2018): 24-34.
- Zhao, Fang, et al. "Stop detection in smartphone-based travel surveys." Transportation research procedia 11 (2015): 218-226.
- Hong, Shuyao, et al. "Insights on data quality from a large-scale application of smartphone-based travel survey technology in the Phoenix metropolitan area, Arizona, USA." Transportation Research Part A: Policy and Practice 154 (2021): 413-429.
- Alho, André, et al. "Online and in-person activity logging using a smartphone-based travel, activity, and time-use survey." Transportation Research Interdisciplinary Perspectives 13 (2022): 100524.

