---
title: "Left Handed Catchers"
author: "Martin Monkman"
date: "Sunday, July 20, 2014"
output: html_document
---

We are approaching the twenty-fifth anniversary of the last time a left-handed throwing catcher appeared behind the plate in a Major League Baseball game; on [August 18, 1989](http://www.fangraphs.com/wins.aspx?date=1989-08-18&team=Braves&dh=0&season=1989) [Benny Distefano](http://www.fangraphs.com/statss.aspx?playerid=1003326&position=1B/OF) made his third and final appearance as a catcher for the Pirates. Distefano's accomplishment was celebrated five years ago, in Alan Schwarz's ["Left-Handed and Left Out"](http://www.nytimes.com/2009/08/16/sports/baseball/16catcher.html) (*New York Times*, 2009-08-15). 

 
Benny Distefano -- 1985 Donruss #166



Jack Moore, writing on the site Sports on Earth in 2013 (["Why no left-handed catchers?"](http://www.sportsonearth.com/article/44139204/milwaukee-could-use-a-left-handed-catcher-would-be-first-baseball-team-to-do-so-since-1989----why-are-left-handed-catchers-so-rare#!bjhKQb)), points out that lack of left-handed catchers goes back a long way. One interesting piece of evidence is a 1948 Ripley's "Believe It Or Not" item with a left-handed catcher Dick Bernard (you can read more about Bernard's signing in the [July 1, 1948 edition of the *Tuscaloosa News*](http://news.google.com/newspapers?nid=1817&dat=19480701&id=EeQ-AAAAIBAJ&sjid=zEwMAAAAIBAJ&pg=6378,59043)).  Bernard didn't make the majors, and doesn't appear in any of the minor league records that are available on-line either.


Dick Bernard in Ripley's "Believe It or Not", 1948-12-30


There are a variety of hypotheses why there are no left-handed catchers, all of which are summarized in John Walsh's ["Top 10 Left-Handed Catchers for 2006"](http://www.hardballtimes.com/top-10-left-handed-catchers-for-2006/) (a tongue-in-cheek title if ever there were) at [The Hardball Times](http://www.hardballtimes.com/).  A compelling explanation, and one supported by both Bill James and J.C. Bradbury (in his book *The Baseball Economist*) is natural selection; a left-handed little league player who can throw well will be groomed as a pitcher.

###Throwing hand by fielding position as an example of a categorical variable

I was looking for some examples of categorical variables to display visually, and the lack of left-handed throwing catchers, compared to other positions, came to mind.  The following uses R, and the [Lahman database package](http://cran.r-project.org/web/packages/Lahman/index.html). 

The analysis requires merging the Master and Fielding tables in the Lahman database -- the Master table gives the throwing hand, and Fielding tells us how many games at each position they played. For the purpose of this analysis, we'll look at the seasons 1945 through 2012.

You may note that for the merging of the two tables, I used the new [dplyr package](http://cran.r-project.org/web/packages/dplyr/index.html).  I tested the system.time of the basic version of "merge" to combine the two tables, and the "inner_join" in dplyr.  The latter is substantially faster:  my aging computer ran "merge" in about 5.5 seconds, compared to 0.17 seconds with dplyr.



```{r}
# load the required packages
require(Lahman)
require(vcd)
require(dplyr)
require(gmodels)
#
# create a new data table that merges the Fielding and Master tables, based on the common variable "playerID"
MasterFielding <- inner_join(Fielding, Master, by="playerID")
# select only those seasons since 1945 and 
# omit the records that are OF summary (i.e. leave the RF, CF, and LF)
MasterFielding <- subset(MasterFielding, POS != "OF" & yearID > "1944")

```
### Cross-tab Tables

Prepare a simple contingency / cross-tab table based on position (POS) and throwing hand (throws).

```{r}
throwPOS <- with(MasterFielding, table(POS, throws))
throwPOS
```

A more elaborate table can be created using the gmodels package. In this case, we'll
use the CrossTable function to generate a table with row percentages.

```{r}
CrossTable(MasterFielding$POS, MasterFielding$throws, 
           digits=2, format="SPSS",
           prop.r=TRUE, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE,  # keeping the row proportions
           chisq=TRUE)                                                 # adding the ChiSquare statistic
```

### Mosaic Plot

A mosaic plot represents the contents of the summary tables in a graphic manner.

```{r, fig.width=7, fig.height=6}
# plot
mosaic(throwPOS, highlighting = "throws", highlighting_fill=c("darkgrey", "white"))
```

### Conclusion

The clear result is that it's not just catchers that are overwhelmingly right-handed throwers, it's also infielders (except first base).  There have been very few southpaws playing second and third base -- and there have been absolutely no left-handed throwing shortstops in this period.

As J.G. Preston puts it in the blog post ["Left-handed throwing second basemen, shortstops and third basemen"](http://prestonjg.wordpress.com/2009/09/06/left-handed-throwing-second-basemen-shortstops-and-third-basemen/),

> While right-handed throwers can be found at any of the nine positions on a baseball field, 
> left-handers are, in practice, restricted to five of them.


My github file for this entry in Markdown is here:
[https://github.com/MonkmanMH/Bayesball/blob/master/LeftHandedCatchers.md]

-30-

