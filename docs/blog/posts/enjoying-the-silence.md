---
date: 2026-06-20
authors:
    - gekkotadev
---

# Enjoying The Silence

It's been a while since the last of these developer logs but I believe that's for the greater good of the project. To solely focus on one thing is to burn oneself out and to seal it in a vacuum away from outside influences.

Since then it's refreshing to gain new perspectives as I experience software engineering outside of this one project and to hear, listen, and watch the perspectives of others' works and opinions.

## Software Exploration

In the time the project had went silent, I've been writing more software both in my free time and as part of my obligations as a member of other teams in my academics. Immersing myself in those has of course instilled me with additional valuable discoveries.

### Dependency Management

Dependency management in Godot had always been something of a subpar experience, not quite ideal when precompiled binaries are involved given Git's limitations with large file storage or convenience for that matter.

One could of course as mentioned commit the addons directly into your repository but this is far from ideal given GDExtension involves binary executables Git simply can't reliably commit.

[Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) won't work either and arguably messier to work with. It still faces the same limitations as Git.

And you can forget instructing developers to manually install addons. This is a tedious process and there's always the room for human error — we're just human after all.

This leaves us with custom tooling.

Since I wouldn't want to build my own tools it would be better to use one that already exists. [`godotenv`](https://github.com/chickensoft-games/godotenv) comes close but doesn't quite reach the needs of the developers. The errors it provides are rather cryptic and the behaviors rather inconsistent.

[Godot Goodie Grabber](https://github.com/godotneers/ggg) (`ggg`) would be the next option and this was something I wished I would've used earlier. It works rather reliably and the feedback it reports is sufficiently descriptive. Installation seems rather straightforward and it has additional features that help keep the project in sync across team members and secure the dependencies used.

Finally, something that works well enough to the spec I need a package manager to be at; to elaborate:

It of course needs to be something that is particularly easy to install and update, and `ggg` compared to other tools is as simple as it gets for command line tools. It's just one shell script to copy and paste to install, and one doesn't even need to manually manage updates as it comes with the utility for that too.

The feedback it provides when running a command had so far been rich in information and nicely formatted so that it's easy to parse at a glance, though frankly I'd be more surprised if a tool written in Rust didn't have such descriptive feedback especially when reporting errors to the user, a good attribute to have in software but even then errors seem to happen more rarely compared to the previous solution the team was using.

What quite seals the deal were that `ggg` allows to map folders within addons to locations where I'd instead prefer them to be installed which works out quite nicely when the addon provides examples, and ways to secure dependencies either by providing a commit ID or a SHA256 hash.

Did I also mention `ggg` can also ensure you're running the correct version of Godot? And even manage export templates?

In all honesty, it seems to be so far the best tool for creating reproducible development environments.

### Project Management

I'm contemplating enforcing the use of something such as Notion or some other project planner because we can't keep making mental notes and promises, and I'd like to remind that the use of [Gyms, Zoos, and Musuems](https://youtu.be/5PJRCz0t7yY) are good for sustainable development of the game; I **urge** the use of such pattern as it serves multiple purposes for experimentation, documentation, and as bonus content for the player.

Mental notes are simply just notes, they are not something that can reliably be followed upon as they inherently don't hold much weight. Our memories are not reliable at recalling information nor are we always a reliable orator as we can always misremember details for whatever reasons — genuinely forgot, internal biases, what-have-its.

Recorded data — notes, documents, et cetera — are a more reliable way of keeping track of thoughts and progress as they're set in stone; things don't get lost to the ether when they're recorded particularly in words and not only is it a more reliable way to note down what needs to be done or shouldn't be done, recording it can also serve double purpose as documentation too.

By recording it can also mean notes, project planners or personal knowledge bases.

While one may say such data can be tampered with, it becomes less of an issue if not disappears entirely the moment revision tracking is implemented. This helps not only in reverting to a previous stage of the document but to also hold accountability.

As for [Gyms, Zoos, and Musuems](https://youtu.be/5PJRCz0t7yY): it's good to have a game design document but what's even better is to have testing areas that can help define the look and feel of the game, and how it should behave, accessible both via an automated testing framework and by the developers or any curious player.

It's not even just some opinion if even [one of the world's best selling game uses this technique](https://minecraft.wiki/w/Debug_mode)

We just can't continue with just mere verbal promises, it's been stressful for all of us isn't it?

## Creative Direction

Well, I recall we're targeting ages of young adults so we're rolling with that it seems.

Despite that however given how far the project is in, the "papercraft" style shall remain not as a limitation but as a creative design choice, something that provides its own charm whilst paying homage to inspirations.

We'll of course remove any insensitive or otherwise discriminatory content that had slipped through during development without sufficient oversight. This means for instance removing "**violent crazy homeless people**" on the grounds that it's **a [tasteless](https://en.wiktionary.org/wiki/tasteless) [caricature](https://en.wiktionary.org/wiki/caricature) that frankly doesn't serve the plot and only serves to [demonize](https://en.wiktionary.org/wiki/demonize#English) a marginalized group**; it's unfortunate given other placeholders were available to be implemented.

We will see where development and progress leads us but as the project lead I'll definitely say this — leave being a quote unquote "edgelord" to the 2000s/2010s and to 𝕏. This obsolete style of thinking rooted in hate against humanity won't benefit the game in the long run.

Otherwise there's not really much to address aside from what had been discussed during defense, just the removal of bigotry.

To keep us grounded and not lose our compassion to others less fortunate, here is [a relevant quote from EBSCO; authored by Browne, Dallas L.](https://www.ebsco.com/research-starters/sociology/bigotry)

> **Bigotry is the obstinate and unreasonable attachment to one’s own opinions or beliefs. Bigots are intolerant of beliefs that oppose their own. Often, such people are very emotional and may become stubbornly intolerant or even hostile toward others who differ with them regarding religion, race, gender, sexual orientation, or other issues**. This state of mind encourages stereotyping, overgeneralization, and other errors that suggest the absence of critical thinking. <br/>
> <br/>
> Bigoted attitudes can be culturally transmitted as part of the education of children or adults. Social experiences, such as family and community upbringing, and environmental factors, such as the media and social norms, play a role. **Bigotry is a learned prejudice that is founded on inaccurate and inflexible overgeneralizations**. Bigots may believe, for example, that “all Black individuals are thieves,” even though they have no experience on which to base this belief. Even if they know a very honest Black individual, they will state that this person is the exception to the rule or has yet to reveal their character. When confronted with new information that contradicts their beliefs, bigots are unwilling to change, but they instead perceive the contradictory evidence as exceptional and may become excited and emotional. <br/>
> <br/>
> Bigotry is not confined to race. Some bigots dislike individuals due to their religion, gender, sexual orientation, or physical appearance. A bigot could dislike someone because they are overweight or have red hair. Bigots discriminate against these populations without cause. However, bigotry, being a learned behavior, is not immutable but can be ameliorated through social policy. It is often difficult for bigots to change their minds because they are highly emotional and cognitively rigid. However, education, fostering positive interactions, and teaching empathy can be effective strategies.

Do bear in mind the paradox of tolerance applies to this definition — that is, the rejection of ideologies whose sole purpose is for the silencing or oppression of others, precisely what actionable bigotry does.

**tl;dr**: I've recognized some less than humane stereotypes had slipped past supervision and this section reminds not to sneak in these prejudices against minorities or otherwise marginalized groups; This isn't about being "woke" or "holier than thou", have some empathy and show some [common decency](https://www.dictionary.com/browse/common-decency), *capiche?*

At the very least, keep the **Ethics** Research Committee in mind.

## Conclusions

That should conclude what I'd like to publish here, having published what discoveries that I felt were worth sharing and addressing some concerns that I see would put the project into jeopardy.

As for myself, I'll go on ahead and continue my work on the game and with my own matters I'll have to assess; g'night mate.
